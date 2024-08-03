import CMPack
import Foundation

class MPTreeReader {
    typealias Node = mpack_node_t

    private(set) var root = Node()

    private var tree = mpack_tree_t()
    private let bytes: [UInt8]

    init?(readFrom bytes: [UInt8]) {
        self.bytes = bytes
        self.bytes.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) { ptr in
                mpack_tree_init_data(&tree, ptr.baseAddress, ptr.count)
            }
        }
        guard mpack_tree_try_parse(&tree) else {
            return nil
        }
        root = mpack_tree_root(&tree)
    }

    deinit {
        mpack_tree_destroy(&tree)
    }

    func contains(_ key: String, in node: Node) -> Bool {
        mpack_node_map_contains_cstr(node, key)
    }

    func isKeyNil(_ key: String, in node: Node) -> Bool {
        mpack_node_is_nil(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> Int {
        let valueNode = mpack_node_map_cstr(node, key)
        let num: any SignedInteger = switch MemoryLayout<Int>.size {
        case 8: mpack_node_i8(valueNode)
        case 16: mpack_node_i16(valueNode)
        case 32: mpack_node_i32(valueNode)
        case 64: mpack_node_i64(valueNode)
        default: fatalError()
        }
        return Int(num)
    }

    func read(_ key: String, in node: Node) -> Int8 {
        mpack_node_i8(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> Int16 {
        mpack_node_i16(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> Int32 {
        mpack_node_i32(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> Int64 {
        mpack_node_i64(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> UInt {
        let valueNode = mpack_node_map_cstr(node, key)
        let num: any UnsignedInteger = switch MemoryLayout<UInt>.size {
        case 8: mpack_node_u8(valueNode)
        case 16: mpack_node_u16(valueNode)
        case 32: mpack_node_u32(valueNode)
        case 64: mpack_node_u64(valueNode)
        default: fatalError()
        }
        return UInt(num)
    }

    func read(_ key: String, in node: Node) -> UInt8 {
        mpack_node_u8(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> UInt16 {
        mpack_node_u16(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> UInt32 {
        mpack_node_u32(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> UInt64 {
        mpack_node_u64(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> Bool {
        mpack_node_bool(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> Float {
        mpack_node_float(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> Double {
        mpack_node_double(mpack_node_map_cstr(node, key))
    }

    func read(_ key: String, in node: Node) -> String? {
        let valueNode = mpack_node_map_cstr(node, key)
        guard let ptr = mpack_node_str(valueNode) else {
            return nil
        }
        let len = mpack_node_strlen(valueNode)
        let data = Data(bytes: ptr, count: len)
        return String(data: data, encoding: .utf8)
    }

    func read(_ key: String, in node: Node) -> Node {
        mpack_node_map_cstr(node, key)
    }

    func isArrayItemNil(_ i: Int, in arrayNode: Node) -> Bool {
        mpack_node_is_nil(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> Int {
        let itemNode = mpack_node_array_at(arrayNode, i)
        let num: any SignedInteger = switch MemoryLayout<Int>.size {
        case 8: mpack_node_i8(itemNode)
        case 16: mpack_node_i16(itemNode)
        case 32: mpack_node_i32(itemNode)
        case 64: mpack_node_i64(itemNode)
        default: fatalError()
        }
        return Int(num)
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> Int8 {
        mpack_node_i8(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> Int16 {
        mpack_node_i16(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> Int32 {
        mpack_node_i32(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> Int64 {
        mpack_node_i64(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> UInt {
        let itemNode = mpack_node_array_at(arrayNode, i)
        let num: any UnsignedInteger = switch MemoryLayout<UInt>.size {
        case 8: mpack_node_u8(itemNode)
        case 16: mpack_node_u16(itemNode)
        case 32: mpack_node_u32(itemNode)
        case 64: mpack_node_u64(itemNode)
        default: fatalError()
        }
        return UInt(num)
    }

    func readArrayLength(of node: Node) -> Int {
        mpack_node_array_length(node)
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> UInt8 {
        mpack_node_u8(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> UInt16 {
        mpack_node_u16(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> UInt32 {
        mpack_node_u32(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> UInt64 {
        mpack_node_u64(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> Bool {
        mpack_node_bool(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> Float {
        mpack_node_float(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> Double {
        mpack_node_double(mpack_node_array_at(arrayNode, i))
    }

    func readInArray(_ i: Int, in arrayNode: Node) -> String? {
        let itemNode = mpack_node_array_at(arrayNode, i)
        guard let ptr = mpack_node_str(itemNode) else {
            return nil
        }
        let len = mpack_node_strlen(itemNode)
        let data = Data(bytes: ptr, count: len)
        return String(data: data, encoding: .utf8)
    }
    
    func readInArray(_ i: Int, in arrayNode: Node) -> Node {
        mpack_node_array_at(arrayNode, i)
    }
}
