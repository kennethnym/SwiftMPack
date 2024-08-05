import Foundation

/// An ``Encoder`` that encodes ``Encodable`` types into msgpack-serialized bytes.
public class MPEncoder: Encoder {
    public let codingPath: [any CodingKey] = []
    public let userInfo: [CodingUserInfoKey: Any] = [:]
    
    var writer = MPWriter()
    
    /// Encodes the given ``Encodable`` value into msgpack-serialized ``Data``.
    ///
    /// Example:
    /// ```swift
    /// struct Person: Encodable {
    ///     let name: String
    /// }
    ///
    /// let person = Person(name: "mai sakurajima")
    /// // data will be the person serialized as a msgpack message.
    /// let data = try MPEncoder.encode(person)
    /// ```
    ///
    /// - parameter value: The value to be encoded
    ///
    /// - returns: The value serialized as msgpack ``Data``.
    public static func encode<T: Encodable>(_ value: T) throws -> Data {
        let encoder = MPEncoder()
        try value.encode(to: encoder)
        guard let data = encoder.writer.getDataAndDestroy() else {
            throw MPError.unknownEncodingError
        }
        return data
    }
    
    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        .init(MPKeyedEncodingContainer(referencing: self, writingTo: writer))
    }
    
    public func unkeyedContainer() -> any UnkeyedEncodingContainer {
        MPUnkeyedEncodingContainer(referencing: self, writingTo: writer)
    }
    
    public func singleValueContainer() -> any SingleValueEncodingContainer {
        MPSingleValueEncodingContainer(referencing: self, writingTo: writer)
    }
}

public class MPKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    public var codingPath: [any CodingKey] = []
    
    private var writer: MPWriter
    private let encoder: Encoder
    
    init(referencing encoder: Encoder, writingTo writer: MPWriter) {
        self.encoder = encoder
        self.writer = writer
        self.writer.beginMap()
    }
    
    deinit {
        self.writer.completeMap()
    }
    
    public func encodeNil(forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.writeNil()
    }
    
    public func encode(_ value: Bool, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(bool: value)
    }
    
    public func encode(_ value: String, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(string: value)
    }
    
    public func encode(_ value: Double, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(double: value)
    }
    
    public func encode(_ value: Float, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(float: value)
    }
    
    public func encode(_ value: Int, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(int: value)
    }
    
    public func encode(_ value: Int8, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(int: value)
    }
    
    public func encode(_ value: Int16, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(int: value)
    }
    
    public func encode(_ value: Int32, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(int: value)
    }
    
    public func encode(_ value: Int64, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(int: value)
    }
    
    public func encode(_ value: UInt, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(uint: value)
    }
    
    public func encode(_ value: UInt8, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(uint: value)
    }
    
    public func encode(_ value: UInt16, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(uint: value)
    }
    
    public func encode(_ value: UInt32, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(uint: value)
    }
    
    public func encode(_ value: UInt64, forKey key: Key) throws {
        writer.write(string: key.stringValue)
        writer.write(uint: value)
    }
    
    public func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        writer.write(string: key.stringValue)
        try value.encode(to: encoder)
    }
    
    public func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        writer.write(string: key.stringValue)
        return KeyedEncodingContainer(MPKeyedEncodingContainer<NestedKey>(referencing: encoder, writingTo: writer))
    }
    
    public func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
        writer.write(string: key.stringValue)
        return MPUnkeyedEncodingContainer(referencing: encoder, writingTo: writer)
    }
    
    public func superEncoder() -> any Encoder { superEncoder(forKey: .init(stringValue: "super")!) }
    
    public func superEncoder(forKey key: Key) -> any Encoder { encoder }
}

class MPUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    var codingPath: [any CodingKey] = []
    
    var count: Int = 0
    
    private let encoder: Encoder
    private var writer: MPWriter
    
    init(referencing encoder: Encoder, writingTo writer: MPWriter) {
        self.encoder = encoder
        self.writer = writer
        self.writer.beginArray()
    }
    
    deinit {
        self.writer.completeArray()
    }
    
    func encodeNil() throws {
        writer.writeNil()
    }
    
    func encode(_ value: Bool) throws {
        writer.write(bool: value)
    }
    
    func encode(_ value: String) throws {
        writer.write(string: value)
    }
    
    func encode(_ value: Double) throws {
        writer.write(double: value)
    }
    
    func encode(_ value: Float) throws {
        writer.write(float: value)
    }
    
    func encode(_ value: Int) throws {
        writer.write(int: value)
    }
    
    func encode(_ value: Int8) throws {
        writer.write(int: value)
    }
    
    func encode(_ value: Int16) throws {
        writer.write(int: value)
    }
    
    func encode(_ value: Int32) throws {
        writer.write(int: value)
    }
    
    func encode(_ value: Int64) throws {
        writer.write(int: value)
    }
    
    func encode(_ value: UInt) throws {
        writer.write(uint: value)
    }
    
    func encode(_ value: UInt8) throws {
        writer.write(uint: value)
    }
    
    func encode(_ value: UInt16) throws {
        writer.write(uint: value)
    }
    
    func encode(_ value: UInt32) throws {
        writer.write(uint: value)
    }
    
    func encode(_ value: UInt64) throws {
        writer.write(uint: value)
    }
    
    func encode<T>(_ value: T) throws where T: Encodable {
        try value.encode(to: encoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        return KeyedEncodingContainer(MPKeyedEncodingContainer(referencing: encoder, writingTo: writer))
    }
    
    func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        return MPUnkeyedEncodingContainer(referencing: encoder, writingTo: writer)
    }
    
    func superEncoder() -> any Encoder { encoder }
}

struct MPSingleValueEncodingContainer: SingleValueEncodingContainer {
    var codingPath: [any CodingKey] = []
    
    private let encoder: Encoder
    private var writer: MPWriter
    
    init(referencing encoder: Encoder, writingTo writer: MPWriter) {
        self.encoder = encoder
        self.writer = writer
    }
    
    mutating func encodeNil() throws {
        writer.writeNil()
    }
    
    mutating func encode(_ value: Bool) throws {
        writer.write(bool: value)
    }
    
    mutating func encode(_ value: String) throws {
        writer.write(string: value)
    }
    
    mutating func encode(_ value: Double) throws {
        writer.write(double: value)
    }
    
    mutating func encode(_ value: Float) throws {
        writer.write(float: value)
    }
    
    mutating func encode(_ value: Int) throws {
        writer.write(int: value)
    }
    
    mutating func encode(_ value: Int8) throws {
        writer.write(int: value)
    }
    
    mutating func encode(_ value: Int16) throws {
        writer.write(int: value)
    }
    
    mutating func encode(_ value: Int32) throws {
        writer.write(int: value)
    }
    
    mutating func encode(_ value: Int64) throws {
        writer.write(int: value)
    }
    
    mutating func encode(_ value: UInt) throws {
        writer.write(uint: value)
    }
    
    mutating func encode(_ value: UInt8) throws {
        writer.write(uint: value)
    }
    
    mutating func encode(_ value: UInt16) throws {
        writer.write(uint: value)
    }
    
    mutating func encode(_ value: UInt32) throws {
        writer.write(uint: value)
    }
    
    mutating func encode(_ value: UInt64) throws {
        writer.write(uint: value)
    }
    
    mutating func encode<T>(_ value: T) throws where T: Encodable {
        try value.encode(to: encoder)
    }
}
