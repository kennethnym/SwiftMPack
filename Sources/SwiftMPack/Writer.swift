import CMPack
import Foundation

struct MPWriter {
    typealias Buffer = UnsafeMutablePointer<CChar>
    
    private var writer = UnsafeMutablePointer<mpack_writer_t>.allocate(capacity: 1)
    private var bufferPtr: UnsafeMutablePointer<Buffer?>
    private var size = UnsafeMutablePointer<Int>.allocate(capacity: 1)

    init() {
        bufferPtr = UnsafeMutablePointer<Buffer?>.allocate(capacity: 1)
        mpack_writer_init_growable(writer, bufferPtr, size)
    }
    
    mutating func beginMap() {
        mpack_build_map(writer)
    }
    
    mutating func completeMap() {
        mpack_complete_map(writer)
    }
    
    mutating func beginArray() {
        mpack_build_array(writer)
    }
    
    mutating func completeArray() {
        mpack_complete_array(writer)
    }
    
    mutating func write(int: Int) {
        switch MemoryLayout<Int>.size {
        case 8:
            mpack_write_i8(writer, Int8(int))
        case 16:
            mpack_write_i16(writer, Int16(int))
        case 32:
            mpack_write_i32(writer, Int32(int))
        case 64:
            mpack_write_i64(writer, Int64(int))
        default:
            fatalError("Unsupported integer size")
        }
    }
    
    mutating func write(int: Int8) {
        mpack_write_i8(writer, int)
    }
    
    mutating func write(int: Int16) {
        mpack_write_i16(writer, int)
    }
    
    mutating func write(int: Int32) {
        mpack_write_i32(writer, int)
    }

    mutating func write(int: Int64) {
        mpack_write_i64(writer, int)
    }
    
    mutating func write(uint: UInt) {
        switch MemoryLayout<UInt>.size {
        case 8:
            mpack_write_u8(writer, UInt8(uint))
        case 16:
            mpack_write_u16(writer, UInt16(uint))
        case 32:
            mpack_write_u32(writer, UInt32(uint))
        case 64:
            mpack_write_u64(writer, UInt64(uint))
        default:
            fatalError("Unsupported integer size")
        }
    }
    
    mutating func write(uint: UInt8) {
        mpack_write_u8(writer, uint)
    }
    
    mutating func write(uint: UInt16) {
        mpack_write_u16(writer, uint)
    }
    
    mutating func write(uint: UInt32) {
        mpack_write_u32(writer, uint)
    }
    
    mutating func write(uint: UInt64) {
        mpack_write_u64(writer, uint)
    }
    
    mutating func write(float: Float) {
        mpack_write_float(writer, float)
    }
    
    mutating func write(double: Double) {
        mpack_write_double(writer, double)
    }
    
    mutating func write(string: String) {
        mpack_write_utf8(writer, string, UInt32(string.utf8.count))
    }
    
    mutating func write(bool: Bool) {
        mpack_write_bool(writer, bool)
    }
    
    mutating func writeNil() {
        mpack_write_nil(writer)
    }
    
    mutating func getDataAndDestroy() -> Data? {
        let error = mpack_writer_destroy(writer)
        if error != mpack_ok {
            return nil
        }
        
        guard let buffer = bufferPtr.pointee else {
            return nil
        }
        
        let data = Data(
            bytesNoCopy: buffer.withMemoryRebound(to: UInt8.self, capacity: size.pointee) { $0 },
            count: size.pointee,
            deallocator: .custom { ptr, _ in
                ptr.deallocate()
            }
        )
        
        bufferPtr.deallocate()
        size.deallocate()
        writer.deallocate()
        
        return data
    }
}

extension MPWriter.Buffer {
    static func create() -> MPWriter.Buffer {
        return MPWriter.Buffer.allocate(capacity: 1)
    }
}
