import Foundation

private typealias FunctionHandler = (MPTreeReader, MPTreeReader.Node) throws -> any Encodable

class RPCServer {
    private var functionHandlers: [String: FunctionHandler] = [:]
    private let channel: MPRPCChannel

    init(over channel: MPRPCChannel) {
        self.channel = channel
        channel.onIncomingData(handler: onIncomingData(_:))
    }

    func function<P0: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let argNode: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg = try MPDecoder.decode(P0.self, with: reader, from: argNode)
            return handler(arg)
        }
    }

    func function<P0: Decodable, P1: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0, P1) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let arg0Node: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg0 = try MPDecoder.decode(P0.self, with: reader, from: arg0Node)
            let arg1Node: MPTreeReader.Node = reader.readInArray(1, in: params)
            let arg1 = try MPDecoder.decode(P1.self, with: reader, from: arg1Node)
            return handler(arg0, arg1)
        }
    }

    func function<P0: Decodable, P1: Decodable, P2: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0, P1, P2) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let arg0Node: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg0 = try MPDecoder.decode(P0.self, with: reader, from: arg0Node)
            let arg1Node: MPTreeReader.Node = reader.readInArray(1, in: params)
            let arg1 = try MPDecoder.decode(P1.self, with: reader, from: arg1Node)
            let arg2Node: MPTreeReader.Node = reader.readInArray(2, in: params)
            let arg2 = try MPDecoder.decode(P2.self, with: reader, from: arg2Node)
            return handler(arg0, arg1, arg2)
        }
    }

    func function<P0: Decodable, P1: Decodable, P2: Decodable, P3: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0, P1, P2, P3) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let arg0Node: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg0 = try MPDecoder.decode(P0.self, with: reader, from: arg0Node)
            let arg1Node: MPTreeReader.Node = reader.readInArray(1, in: params)
            let arg1 = try MPDecoder.decode(P1.self, with: reader, from: arg1Node)
            let arg2Node: MPTreeReader.Node = reader.readInArray(2, in: params)
            let arg2 = try MPDecoder.decode(P2.self, with: reader, from: arg2Node)
            let arg3Node: MPTreeReader.Node = reader.readInArray(3, in: params)
            let arg3 = try MPDecoder.decode(P3.self, with: reader, from: arg3Node)
            return handler(arg0, arg1, arg2, arg3)
        }
    }

    func function<P0: Decodable, P1: Decodable, P2: Decodable, P3: Decodable, P4: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0, P1, P2, P3, P4) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let arg0Node: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg0 = try MPDecoder.decode(P0.self, with: reader, from: arg0Node)
            let arg1Node: MPTreeReader.Node = reader.readInArray(1, in: params)
            let arg1 = try MPDecoder.decode(P1.self, with: reader, from: arg1Node)
            let arg2Node: MPTreeReader.Node = reader.readInArray(2, in: params)
            let arg2 = try MPDecoder.decode(P2.self, with: reader, from: arg2Node)
            let arg3Node: MPTreeReader.Node = reader.readInArray(3, in: params)
            let arg3 = try MPDecoder.decode(P3.self, with: reader, from: arg3Node)
            let arg4Node: MPTreeReader.Node = reader.readInArray(4, in: params)
            let arg4 = try MPDecoder.decode(P4.self, with: reader, from: arg4Node)
            return handler(arg0, arg1, arg2, arg3, arg4)
        }
    }

    func function<P0: Decodable, P1: Decodable, P2: Decodable, P3: Decodable, P4: Decodable, P5: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0, P1, P2, P3, P4, P5) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let arg0Node: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg0 = try MPDecoder.decode(P0.self, with: reader, from: arg0Node)
            let arg1Node: MPTreeReader.Node = reader.readInArray(1, in: params)
            let arg1 = try MPDecoder.decode(P1.self, with: reader, from: arg1Node)
            let arg2Node: MPTreeReader.Node = reader.readInArray(2, in: params)
            let arg2 = try MPDecoder.decode(P2.self, with: reader, from: arg2Node)
            let arg3Node: MPTreeReader.Node = reader.readInArray(3, in: params)
            let arg3 = try MPDecoder.decode(P3.self, with: reader, from: arg3Node)
            let arg4Node: MPTreeReader.Node = reader.readInArray(4, in: params)
            let arg4 = try MPDecoder.decode(P4.self, with: reader, from: arg4Node)
            let arg5Node: MPTreeReader.Node = reader.readInArray(5, in: params)
            let arg5 = try MPDecoder.decode(P5.self, with: reader, from: arg5Node)
            return handler(arg0, arg1, arg2, arg3, arg4, arg5)
        }
    }

    func function<P0: Decodable, P1: Decodable, P2: Decodable, P3: Decodable, P4: Decodable, P5: Decodable, P6: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0, P1, P2, P3, P4, P5, P6) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let arg0Node: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg0 = try MPDecoder.decode(P0.self, with: reader, from: arg0Node)
            let arg1Node: MPTreeReader.Node = reader.readInArray(1, in: params)
            let arg1 = try MPDecoder.decode(P1.self, with: reader, from: arg1Node)
            let arg2Node: MPTreeReader.Node = reader.readInArray(2, in: params)
            let arg2 = try MPDecoder.decode(P2.self, with: reader, from: arg2Node)
            let arg3Node: MPTreeReader.Node = reader.readInArray(3, in: params)
            let arg3 = try MPDecoder.decode(P3.self, with: reader, from: arg3Node)
            let arg4Node: MPTreeReader.Node = reader.readInArray(4, in: params)
            let arg4 = try MPDecoder.decode(P4.self, with: reader, from: arg4Node)
            let arg5Node: MPTreeReader.Node = reader.readInArray(5, in: params)
            let arg5 = try MPDecoder.decode(P5.self, with: reader, from: arg5Node)
            let arg6Node: MPTreeReader.Node = reader.readInArray(6, in: params)
            let arg6 = try MPDecoder.decode(P6.self, with: reader, from: arg6Node)
            return handler(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
        }
    }

    func function<P0: Decodable, P1: Decodable, P2: Decodable, P3: Decodable, P4: Decodable, P5: Decodable, P6: Decodable, P7: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0, P1, P2, P3, P4, P5, P6, P7) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let arg0Node: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg0 = try MPDecoder.decode(P0.self, with: reader, from: arg0Node)
            let arg1Node: MPTreeReader.Node = reader.readInArray(1, in: params)
            let arg1 = try MPDecoder.decode(P1.self, with: reader, from: arg1Node)
            let arg2Node: MPTreeReader.Node = reader.readInArray(2, in: params)
            let arg2 = try MPDecoder.decode(P2.self, with: reader, from: arg2Node)
            let arg3Node: MPTreeReader.Node = reader.readInArray(3, in: params)
            let arg3 = try MPDecoder.decode(P3.self, with: reader, from: arg3Node)
            let arg4Node: MPTreeReader.Node = reader.readInArray(4, in: params)
            let arg4 = try MPDecoder.decode(P4.self, with: reader, from: arg4Node)
            let arg5Node: MPTreeReader.Node = reader.readInArray(5, in: params)
            let arg5 = try MPDecoder.decode(P5.self, with: reader, from: arg5Node)
            let arg6Node: MPTreeReader.Node = reader.readInArray(6, in: params)
            let arg6 = try MPDecoder.decode(P6.self, with: reader, from: arg6Node)
            let arg7Node: MPTreeReader.Node = reader.readInArray(7, in: params)
            let arg7 = try MPDecoder.decode(P7.self, with: reader, from: arg7Node)
            return handler(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
        }
    }

    func function<P0: Decodable, P1: Decodable, P2: Decodable, P3: Decodable, P4: Decodable, P5: Decodable, P6: Decodable, P7: Decodable, P8: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0, P1, P2, P3, P4, P5, P6, P7, P8) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let arg0Node: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg0 = try MPDecoder.decode(P0.self, with: reader, from: arg0Node)
            let arg1Node: MPTreeReader.Node = reader.readInArray(1, in: params)
            let arg1 = try MPDecoder.decode(P1.self, with: reader, from: arg1Node)
            let arg2Node: MPTreeReader.Node = reader.readInArray(2, in: params)
            let arg2 = try MPDecoder.decode(P2.self, with: reader, from: arg2Node)
            let arg3Node: MPTreeReader.Node = reader.readInArray(3, in: params)
            let arg3 = try MPDecoder.decode(P3.self, with: reader, from: arg3Node)
            let arg4Node: MPTreeReader.Node = reader.readInArray(4, in: params)
            let arg4 = try MPDecoder.decode(P4.self, with: reader, from: arg4Node)
            let arg5Node: MPTreeReader.Node = reader.readInArray(5, in: params)
            let arg5 = try MPDecoder.decode(P5.self, with: reader, from: arg5Node)
            let arg6Node: MPTreeReader.Node = reader.readInArray(6, in: params)
            let arg6 = try MPDecoder.decode(P6.self, with: reader, from: arg6Node)
            let arg7Node: MPTreeReader.Node = reader.readInArray(7, in: params)
            let arg7 = try MPDecoder.decode(P7.self, with: reader, from: arg7Node)
            let arg8Node: MPTreeReader.Node = reader.readInArray(8, in: params)
            let arg8 = try MPDecoder.decode(P8.self, with: reader, from: arg8Node)
            return handler(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        }
    }

    func function<P0: Decodable, P1: Decodable, P2: Decodable, P3: Decodable, P4: Decodable, P5: Decodable, P6: Decodable, P7: Decodable, P8: Decodable, P9: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let arg0Node: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg0 = try MPDecoder.decode(P0.self, with: reader, from: arg0Node)
            let arg1Node: MPTreeReader.Node = reader.readInArray(1, in: params)
            let arg1 = try MPDecoder.decode(P1.self, with: reader, from: arg1Node)
            let arg2Node: MPTreeReader.Node = reader.readInArray(2, in: params)
            let arg2 = try MPDecoder.decode(P2.self, with: reader, from: arg2Node)
            let arg3Node: MPTreeReader.Node = reader.readInArray(3, in: params)
            let arg3 = try MPDecoder.decode(P3.self, with: reader, from: arg3Node)
            let arg4Node: MPTreeReader.Node = reader.readInArray(4, in: params)
            let arg4 = try MPDecoder.decode(P4.self, with: reader, from: arg4Node)
            let arg5Node: MPTreeReader.Node = reader.readInArray(5, in: params)
            let arg5 = try MPDecoder.decode(P5.self, with: reader, from: arg5Node)
            let arg6Node: MPTreeReader.Node = reader.readInArray(6, in: params)
            let arg6 = try MPDecoder.decode(P6.self, with: reader, from: arg6Node)
            let arg7Node: MPTreeReader.Node = reader.readInArray(7, in: params)
            let arg7 = try MPDecoder.decode(P7.self, with: reader, from: arg7Node)
            let arg8Node: MPTreeReader.Node = reader.readInArray(8, in: params)
            let arg8 = try MPDecoder.decode(P8.self, with: reader, from: arg8Node)
            let arg9Node: MPTreeReader.Node = reader.readInArray(9, in: params)
            let arg9 = try MPDecoder.decode(P9.self, with: reader, from: arg9Node)
            return handler(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
        }
    }

    func function<P0: Decodable, P1: Decodable, P2: Decodable, P3: Decodable, P4: Decodable, P5: Decodable, P6: Decodable, P7: Decodable, P8: Decodable, P9: Decodable, P10: Decodable, ReturnValue: Encodable>(_ functionName: String, _ handler: @escaping (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10) -> ReturnValue) {
        functionHandlers[functionName] = { (reader: MPTreeReader, params: MPTreeReader.Node) -> ReturnValue in
            let arg0Node: MPTreeReader.Node = reader.readInArray(0, in: params)
            let arg0 = try MPDecoder.decode(P0.self, with: reader, from: arg0Node)
            let arg1Node: MPTreeReader.Node = reader.readInArray(1, in: params)
            let arg1 = try MPDecoder.decode(P1.self, with: reader, from: arg1Node)
            let arg2Node: MPTreeReader.Node = reader.readInArray(2, in: params)
            let arg2 = try MPDecoder.decode(P2.self, with: reader, from: arg2Node)
            let arg3Node: MPTreeReader.Node = reader.readInArray(3, in: params)
            let arg3 = try MPDecoder.decode(P3.self, with: reader, from: arg3Node)
            let arg4Node: MPTreeReader.Node = reader.readInArray(4, in: params)
            let arg4 = try MPDecoder.decode(P4.self, with: reader, from: arg4Node)
            let arg5Node: MPTreeReader.Node = reader.readInArray(5, in: params)
            let arg5 = try MPDecoder.decode(P5.self, with: reader, from: arg5Node)
            let arg6Node: MPTreeReader.Node = reader.readInArray(6, in: params)
            let arg6 = try MPDecoder.decode(P6.self, with: reader, from: arg6Node)
            let arg7Node: MPTreeReader.Node = reader.readInArray(7, in: params)
            let arg7 = try MPDecoder.decode(P7.self, with: reader, from: arg7Node)
            let arg8Node: MPTreeReader.Node = reader.readInArray(8, in: params)
            let arg8 = try MPDecoder.decode(P8.self, with: reader, from: arg8Node)
            let arg9Node: MPTreeReader.Node = reader.readInArray(9, in: params)
            let arg9 = try MPDecoder.decode(P9.self, with: reader, from: arg9Node)
            let arg10Node: MPTreeReader.Node = reader.readInArray(10, in: params)
            let arg10 = try MPDecoder.decode(P10.self, with: reader, from: arg10Node)
            return handler(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        }
    }

    private func onIncomingData(_ data: Data) {
        guard let reader = MPTreeReader(readFrom: data) else {
            return
        }

        let msgType: Int = reader.readInArray(0, in: reader.root)
        let msgid: UInt32 = reader.readInArray(1, in: reader.root)
        switch msgType {
        case RPCMessageType.request.rawValue:
            guard let methodName: String = reader.readInArray(2, in: reader.root),
                  let handler = functionHandlers[methodName]
            else {
                return
            }

            let params: MPTreeReader.Node = reader.readInArray(3, in: reader.root)

            let response: MPRPCResponse = if let returnValue = try? handler(reader, params) {
                .init(msgid: msgid, result: .success(returnValue))
            } else {
                .init(msgid: msgid, result: .failure(MPRPCCallError()))
            }

            guard let encoded = try? MPEncoder.encode(response) else {
                return
            }

            channel.send(data: encoded)

        default:
            break
        }
    }
}
