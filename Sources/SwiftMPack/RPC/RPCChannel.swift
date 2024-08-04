import Foundation

public protocol MPRPCChannel {
    func send(data: Data)

    func onIncomingData(handler: (Data) -> Void)
}
