import CMPack
import Foundation

/// A ``Decoder`` that decodes msgpack-serialized bytes into ``Decodable`` structs.
public class MPDecoder: Decoder {
    public let codingPath: [any CodingKey] = []
    public let userInfo: [CodingUserInfoKey: Any] = [:]
    
    fileprivate let reader: MPTreeReader
    fileprivate var codingNodes: [MPTreeReader.Node] = []
    
    /// Decodes the given msgpack-formatted bytes into the given ``Decodable`` type.
    ///
    /// Example:
    ///
    /// ```swift
    /// struct Person: Decodable {
    ///     let name: String
    /// }
    ///
    /// let person = try MPData.decode(Person.self, from: serializedPersonData)
    /// ```
    ///
    /// - parameter type: The Decodable type to decode into.
    /// - parameter data: The msgpack-formatted ``Data`` to be decoded.
    ///
    /// - returns: The decoded data in the given type.
    static func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        guard let reader = MPTreeReader(readFrom: data) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unable to decode: invalid mpack data!!"))
        }
        let decoder = MPDecoder(from: reader)
        return try .init(from: decoder)
    }
    
    static func decode<T: Decodable>(_ type: T.Type, with reader: MPTreeReader, from node: MPTreeReader.Node) throws -> T {
        let decoder = MPDecoder(from: reader, startingFrom: node)
        return try .init(from: decoder)
    }

    fileprivate init(from reader: MPTreeReader) {
        self.reader = reader
        codingNodes.append(reader.root)
    }
    
    fileprivate init(from reader: MPTreeReader, startingFrom node: MPTreeReader.Node) {
        self.reader = reader
        codingNodes.append(node)
    }
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        return .init(MPKeyedDecodingContainer(referencing: self))
    }
    
    public func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        MPUnkeyedDecodingContainer(referencing: self)
    }
    
    public func singleValueContainer() throws -> any SingleValueDecodingContainer {
        MPSingleValueDecodingContainer(referencing: self)
    }
}

class MPKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    let codingPath: [any CodingKey] = []
    let allKeys: [Key] = []
    
    private let decoder: MPDecoder
    private let currentNode: MPTreeReader.Node
    
    init(referencing decoder: MPDecoder) {
        self.decoder = decoder
        self.currentNode = decoder.codingNodes.last!
    }
    
    deinit {
        decoder.codingNodes.removeLast()
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
        decoder.codingNodes.append(nextNode)
        return try .init(from: decoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        KeyedDecodingContainer(MPKeyedDecodingContainer<NestedKey>(referencing: decoder))
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
        MPUnkeyedDecodingContainer(referencing: decoder)
    }
    
    func superDecoder() throws -> any Decoder { try superDecoder(forKey: .init(stringValue: "super")!) }
    
    func superDecoder(forKey key: Key) throws -> any Decoder { decoder }
}

class MPUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var codingPath: [any CodingKey] = []
    var isAtEnd: Bool { _count == currentIndex }
    var count: Int? { _count }
    
    private let decoder: MPDecoder
    private let currentNode: MPTreeReader.Node
    
    private var _count: Int
    private(set) var currentIndex: Int = 0
    
    init(referencing decoder: MPDecoder) {
        self.decoder = decoder
        self.currentNode = decoder.codingNodes.last!
        self._count = decoder.reader.readArrayLength(of: currentNode)
    }
    
    deinit {
        decoder.codingNodes.removeLast()
    }
    
    func decodeNil() throws -> Bool {
        let isNil = decoder.reader.isArrayItemNil(currentIndex, in: currentNode)
        currentIndex += 1
        return isNil
    }
    
    func decode(_ type: String.Type) throws -> String {
        guard let str: String = decoder.reader.readInArray(currentIndex, in: currentNode) else {
            throw DecodingError.dataCorruptedError(in: self, debugDescription: "Invalid string at index \(currentIndex)")
        }
        currentIndex += 1
        return str
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        let value: Double = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        let value: Float = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        let value: Int = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        let value: Int8 = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        let value: Int16 = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        let value: Int32 = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        let value: Int64 = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        let value: UInt = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        let value: UInt8 = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        let value: UInt16 = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        let value: UInt32 = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        let value: UInt64 = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        let value: Bool = decoder.reader.readInArray(currentIndex, in: currentNode)
        currentIndex += 1
        return value
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        let node: MPTreeReader.Node = decoder.reader.readInArray(currentIndex, in: currentNode)
        decoder.codingNodes.append(node)
        let value = try type.init(from: decoder)
        currentIndex += 1
        return value
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        .init(MPKeyedDecodingContainer(referencing: decoder))
    }
    
    func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
        MPUnkeyedDecodingContainer(referencing: decoder)
    }
    
    func superDecoder() throws -> any Decoder { decoder }
}

class MPSingleValueDecodingContainer: SingleValueDecodingContainer {
    let codingPath: [any CodingKey] = []
    
    private let decoder: MPDecoder
    private let currentNode: MPTreeReader.Node
    
    init(referencing decoder: MPDecoder) {
        self.decoder = decoder
        self.currentNode = decoder.codingNodes.last!
    }
    
    deinit {
        decoder.codingNodes.removeLast()
    }
    
    func decodeNil() -> Bool {
        mpack_node_is_nil(currentNode)
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        mpack_node_bool(currentNode)
    }
    
    func decode(_ type: String.Type) throws -> String {
        guard let cstr = mpack_node_str(currentNode) else {
            throw DecodingError.dataCorruptedError(in: self, debugDescription: "Unable to decode single value as string: invalid string!")
        }
        let cstrLen = mpack_node_strlen(currentNode)
        let data = Data(bytes: cstr, count: cstrLen)
        guard let str = String(data: data, encoding: .utf8) else {
            throw DecodingError.dataCorruptedError(in: self, debugDescription: "Unable to decode single value as string: invalid string!")
        }
        return str
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        mpack_node_double(currentNode)
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        mpack_node_float(currentNode)
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        let num: any SignedInteger = switch MemoryLayout<Int>.size {
        case 8: mpack_node_i8(currentNode)
        case 16: mpack_node_i16(currentNode)
        case 32: mpack_node_i32(currentNode)
        case 64: mpack_node_i64(currentNode)
        default: fatalError()
        }
        return Int(num)
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        mpack_node_i8(currentNode)
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        mpack_node_i16(currentNode)
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        mpack_node_i32(currentNode)
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        mpack_node_i64(currentNode)
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        let num: any UnsignedInteger = switch MemoryLayout<UInt>.size {
        case 8: mpack_node_u8(currentNode)
        case 16: mpack_node_u16(currentNode)
        case 32: mpack_node_u32(currentNode)
        case 64: mpack_node_u64(currentNode)
        default: fatalError()
        }
        return UInt(num)
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        mpack_node_u8(currentNode)
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        mpack_node_u16(currentNode)
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        mpack_node_u32(currentNode)
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        mpack_node_u64(currentNode)
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        try .init(from: decoder)
    }
}
