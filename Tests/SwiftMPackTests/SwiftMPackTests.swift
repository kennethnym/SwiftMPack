@testable import SwiftMPack
import XCTest

final class SwiftMPackTests: XCTestCase {
    func testExample() throws {
        let buffer = MPWriter.Buffer.create()
        var writer = MPWriter(buffer: buffer)
        writer.beginMap()
        writer.write(string: "hello")
        writer.write(string: "world")
        writer.completeMap()
    }
}
