import Foundation

public protocol MPRPCChannel {
    func send(data: Data)

    func onIncomingData(handler: @escaping (Data) -> Void)
}

public class MPRPCInMemoryRPCChannel: MPRPCChannel {
    private var handler: ((Data) -> Void)?
    public var otherChannel: MPRPCInMemoryRPCChannel?

    public init() {}

    public init(sendTo channel: MPRPCInMemoryRPCChannel) {
        otherChannel = channel
    }

    public func send(data: Data) {
        otherChannel?.received(data: data)
    }

    func received(data: Data) {
        if let handler = handler {
            DispatchQueue.global(qos: .default).async {
                handler(data)
            }
        }
    }

    public func onIncomingData(handler: @escaping (Data) -> Void) {
        self.handler = handler
    }
}
