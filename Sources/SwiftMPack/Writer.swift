import CMPack
import Foundation

/// A thin wrapper around `mpack_writer_*` API calls.
///
/// You normally do not need to interact with this class. Instead, use Swift's ``Codable`` protocol
/// and the provided ``MPEncoder`` and ``MPDecoder`` to encode and decode values.
/// This is exposed for users when the encoder and decoder interfaces aren't enough.
///
/// Internally, MPWriter holds a reference to ``mpack_writer_t``, a reference to a char buffer,
/// as well as a reference to an int that holds the size of the resulting buffer.
/// The char buffer and the size will be written to by mpack once the writing is marked complete
/// by calling ``getDataAndDestroy``.
/// As the name suggests, the writer instance, as well as all other unneeded pointers, will be destroyed and deallocated
/// once it is called. The char buffer will be held onto as long as the returned ``Data`` is in use.
struct MPWriter {
    typealias Buffer = UnsafeMutablePointer<CChar>
    
    private var writer = UnsafeMutablePointer<mpack_writer_t>.allocate(capacity: 1)
    private var bufferPtr = UnsafeMutablePointer<Buffer?>.allocate(capacity: 1)
    private var size = UnsafeMutablePointer<Int>.allocate(capacity: 1)

    /// Creates a new instance and initializes the internal mpack writer.
    init() {
        mpack_writer_init_growable(writer, bufferPtr, size)
    }
    
    /// Begins a new map in the buffer.
    ///
    /// Once the map is fully written, you **must** call ``completeMap``.
    /// You can nest ``beginMap``/``beginArray`` calls, but each call
    /// must be matched with a corresponding ``completeMap``/``completeArray`` call.
    mutating func beginMap() {
        mpack_build_map(writer)
    }
    
    /// Marks the map currently being built in the buffer as complete.
    mutating func completeMap() {
        mpack_complete_map(writer)
    }
    
    /// Begins a new array in the buffer.
    ///
    /// Once the map is fully written, you **must** call ``completeMap``.
    /// You can nest ``beginMap``/``beginArray`` calls, but each call
    /// must be matched with a corresponding ``completeMap``/``completeArray`` call.
    mutating func beginArray() {
        mpack_build_array(writer)
    }
    
    /// Marks the array currently being built in the buffer as complete.
    mutating func completeArray() {
        mpack_complete_array(writer)
    }
    
    /// Writes the given ``Int`` to the buffer using the smallest space possible.
    mutating func write(int: Int) {
        mpack_write_int(writer, Int64(int))
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
    
    /// Writes the given uint to the buffer using the smallest space possible.
    mutating func write(uint: UInt) {
        mpack_write_uint(writer, UInt64(uint))
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
    
    /// Marks the writing as complete, destroys the internal mpack writer,
    /// and returns the written buffer as ``Data`` without copying.
    ///
    /// **The writer cannot be used again after this is called.**
    /// To serialize another message, create a new ``MPWriter`` instance.
    ///
    /// - returns: the serialized bytes as ``Data`` without copying.
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
