import Foundation

private struct MPRPCRequest: Encodable {
    let msgid: MessageID
    let method: String
    let params: [any Codable]

    func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(RPCMessageType.request.rawValue)
        try container.encode(msgid)
        try container.encode(method)
        var paramsContainer = container.nestedUnkeyedContainer()
        try params.forEach {
            try paramsContainer.encode($0)
        }
    }
}

private enum MPRPCResponse {
    /// The RPC server returned an error for this RPC call.
    case error

    /// The RPC call was successful. The ``MPTreeReader.Node`` contains the returned value
    /// which can be read by the given ``MPTreeReader``.
    case ok(MPTreeReader, MPTreeReader.Node)
}

private typealias MessageID = UInt32
private typealias ResponseHandler = (MPRPCResponse) -> Void

struct MPRPCCallError: Error {}

public class MPRPCClient {
    private var pendingRequest: [MessageID: ResponseHandler] = [:]
    private var channel: MPRPCChannel

    public init(over channel: MPRPCChannel) {
        self.channel = channel
        self.channel.onIncomingData(handler: onIncomingData(_:))
    }

    public func call<CallResult: Decodable>(_ method: String, _ args: Codable...) throws -> CallResult {
        let msgid = newMessageID()
        let request = MPRPCRequest(msgid: msgid, method: method, params: args)
        let encoded = try MPEncoder.encode(request)

        let group = DispatchGroup()
        var maybeResult: CallResult?

        group.enter()
        pendingRequest[msgid] = { (response: MPRPCResponse) in
            maybeResult = switch response {
            case .error: nil
            case .ok(let reader, let node):
                try? MPDecoder.decode(CallResult.self, with: reader, from: node)
            }
            group.leave()
        }
        group.wait()

        guard let result = maybeResult else {
            throw MPRPCCallError()
        }
        return result
    }

    @available(macOS 10.15, *)
    public func call<CallResult: Decodable>(_ method: String, _ args: Codable...) async throws -> CallResult {
        let msgid = newMessageID()
        let request = MPRPCRequest(msgid: msgid, method: method, params: args)
        let encoded = try MPEncoder.encode(request)

        return try await withCheckedThrowingContinuation { continuation in
            pendingRequest[msgid] = { (response: MPRPCResponse) in
                switch response {
                case .error:
                    continuation.resume(throwing: MPRPCCallError())
                case .ok(let reader, let node):
                    if let result = try? MPDecoder.decode(CallResult.self, with: reader, from: node) {
                        continuation.resume(returning: result)
                    } else {
                        continuation.resume(throwing: MPRPCCallError())
                    }
                }
            }
        }
    }

    private func onIncomingData(_ data: Data) {
        guard let reader = MPTreeReader(readFrom: data) else {
            return
        }

        let msgType: Int = reader.readInArray(0, in: reader.root)

        switch msgType {
        case RPCMessageType.response.rawValue:
            let msgid: UInt32 = reader.readInArray(1, in: reader.root)
            guard let handler = pendingRequest[msgid] else {
                break
            }

            let hasError = reader.isArrayItemNil(2, in: reader.root)
            if hasError {
                handler(.error)
            } else {
                let value: MPTreeReader.Node = reader.readInArray(3, in: reader.root)
                handler(.ok(reader, value))
            }
            pendingRequest.removeValue(forKey: msgid)

        default:
            break
        }
    }

    private func newMessageID() -> MessageID {
        var id: MessageID
        repeat {
            id = MessageID.random(in: 0 ... MessageID.max)
        } while pendingRequest[id] != nil
        return id
    }
}
