//
//  File.swift
//
//
//  Created by Kenneth on 04/08/2024.
//

import Foundation

enum RPCMessageType: Int {
    case request = 0
    case response = 1
}

typealias MessageID = UInt32

struct MPRPCRequest: Encodable {
    let msgid: MessageID
    let method: String
    let params: [any Codable]

    func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(RPCMessageType.request.rawValue)
        try container.encode(msgid)
        try container.encode(method)
        var paramsContainer = container.nestedUnkeyedContainer()
        try params.forEach {
            try paramsContainer.encode($0)
        }
    }
}

struct MPRPCResponse: Encodable {
    let msgid: MessageID
    let result: Result<any Encodable, MPRPCCallError>

    func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(RPCMessageType.response.rawValue)
        try container.encode(msgid)
        switch result {
        case .success(let success):
            try container.encodeNil()
            try container.encode(success)
        case .failure(let failure):
            try container.encode(failure)
            try container.encodeNil()
        }
    }
}

struct MPRPCCallError: Error, Encodable {}
