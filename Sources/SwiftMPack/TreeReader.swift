import CMPack
import Foundation

struct Reader: ~Copyable {
    private var tree = mpack_tree_t()
    private var root: mpack_node_t
    private let bytes: [UInt8]

    init(bytes: [UInt8]) {
        self.bytes = bytes
        self.bytes.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) { ptr in
                mpack_tree_init_data(&tree, ptr.baseAddress, ptr.count)
                root = mpack_tree_root(&tree)
            }
        }
    }

    subscript(key: String) -> Bool {
        mpack_node_bool(mpack_node_map_cstr(root, key))
    }

    subscript(key: String) -> Bool? {
        let node = mpack_node_map_cstr(root, key)
        if mpack_node_is_nil(node) {
            return nil
        }
        return mpack_node_bool(node)
    }
}
