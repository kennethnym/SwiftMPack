import Foundation

private enum PendingRequestResult {
    /// The RPC server returned an error for this RPC call.
    case error

    /// The RPC call was successful. The ``MPTreeReader.Node`` contains the returned value
    /// which can be read by the given ``MPTreeReader``.
    case ok(MPTreeReader, MPTreeReader.Node)
}

private typealias PendingRequestCallback = (PendingRequestResult) -> Void

public class MPRPCClient {
    private var pendingRequest: [MessageID: PendingRequestCallback] = [:]
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
        pendingRequest[msgid] = { (response: PendingRequestResult) in
            maybeResult = switch response {
            case .error: nil
            case .ok(let reader, let node):
                try? MPDecoder.decode(CallResult.self, with: reader, from: node)
            }
            group.leave()
        }

        channel.send(data: encoded)
        group.enter()
        group.wait()

        guard let result = maybeResult else {
            throw MPRPCCallError()
        }
        return result
    }

    public func call<CallResult: Decodable>(_ method: String, _ args: Codable..., completionHandler: @escaping (CallResult?) -> Void) throws {
        let msgid = newMessageID()
        let request = MPRPCRequest(msgid: msgid, method: method, params: args)
        let encoded = try MPEncoder.encode(request)

        pendingRequest[msgid] = { (response: PendingRequestResult) in
            switch response {
            case .error:
                completionHandler(nil)

            case .ok(let reader, let node):
                completionHandler(try? MPDecoder.decode(CallResult.self, with: reader, from: node))
            }
        }

        channel.send(data: encoded)
    }

    @available(iOS 13, macOS 10.15, *)
    public func call<CallResult: Decodable>(_ method: String, _ args: Codable...) async throws -> CallResult {
        let msgid = newMessageID()
        let request = MPRPCRequest(msgid: msgid, method: method, params: args)
        let encoded = try MPEncoder.encode(request)

        channel.send(data: encoded)

        return try await withCheckedThrowingContinuation { continuation in
            pendingRequest[msgid] = { (response: PendingRequestResult) in
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
