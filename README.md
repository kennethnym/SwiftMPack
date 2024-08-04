# SwiftMPack

SwiftMPack is a thin Swift wrapper around [`mpack`](https://github.com/ludocode/mpack), providing a more convenient Swift interface to mpack's API,
as well as a msgpack RPC implementation in Swift which mpack lacks.

## Usage

### Quick example

```swift
import SwiftMPack

struct Device: Codable {
    let name: String
    let location: Location
}

struct Location: Codable {
    let x: Double
    let y: Double
}

let myDevice = Device(
    name: "My iPhone",
    location: Location(x: 123, y: 456)
)

// myDevice serialized to msgpack bytes
let encodedData = try! MPEncoder.encode(myDevice)

// get Device back from msgpack-encoded data
let decodedDevice = try! MPDecoder.decode(Device.self, from: encodedData)
```

### Optional handling

By default, optional fields that have `nil` as their values are skipped by Swift and won't be encoded as msgpack nil values.
You can work around this by implementing your own encode method within your `Codable` structs/classes.
The example below is borroed from this [StackOverflow answer](https://stackoverflow.com/questions/47266862/encode-nil-value-as-null-with-jsonencoder/47268112).
Although the question was about JSON encoding, the same logic applies with SwiftMPack as they both work with the Codable protocol.

```swift
struct Foo: Codable {
    var string: String? = nil
    var number: Int = 1

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number, forKey: .number)
        try container.encode(string, forKey: .string)
    }
}
```
