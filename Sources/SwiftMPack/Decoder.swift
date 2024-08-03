import Foundation

class MPDecoder: Decoder {
    var codingPath: [any CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    
    fileprivate let reader: MPTreeReader
    fileprivate var codingNode: [MPTreeReader.Node] = []
    
    static func decode<T: Decodable>(_ type: T.Type, from bytes: [UInt8]) throws -> T {
        guard let reader = MPTreeReader(readFrom: bytes) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unable to decode: invalid mpack data!!"))
        }
        let decoder = MPDecoder(startingFrom: reader.root, readingFrom: reader)
        return try .init(from: decoder)
    }
    
    init(startingFrom node: MPTreeReader.Node, readingFrom reader: MPTreeReader) {
        self.reader = reader
        codingNode.append(node)
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        return .init(MPKeyedDecodingContainer(referencing: self))
    }
    
    func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        fatalError()
    }
    
    func singleValueContainer() throws -> any SingleValueDecodingContainer {
        fatalError()
    }
}

class MPKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [any CodingKey] = []
    var allKeys: [Key] = []
    
    private let decoder: MPDecoder
    private let currentNode: MPTreeReader.Node
    
    init(referencing decoder: MPDecoder) {
        self.decoder = decoder
        self.currentNode = decoder.codingNode.last!
    }
    
    deinit {
        decoder.codingNode.removeLast()
    }
    
    func contains(_ key: Key) -> Bool {
        decoder.reader.contains(key.stringValue, in: currentNode)
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        decoder.reader.isKeyNil(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        guard let str: String = decoder.reader.read(key.stringValue, in: currentNode) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "unable to decode string keyed by \(key.stringValue)"))
        }
        return str
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        decoder.reader.read(key.stringValue, in: currentNode)
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
        let nextNode: MPTreeReader.Node = decoder.reader.read(key.stringValue, in: currentNode)
        decoder.codingNode.append(nextNode)
        return try .init(from: decoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        return KeyedDecodingContainer(MPKeyedDecodingContainer<NestedKey>(referencing: decoder))
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
        fatalError()
    }
    
    func superDecoder() throws -> any Decoder {
        fatalError()
    }
    
    func superDecoder(forKey key: Key) throws -> any Decoder {
        fatalError()
    }
}
