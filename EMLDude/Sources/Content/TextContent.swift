//
//  TextContent.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

public struct TextContent: Content {
    public enum SubTypes: String {
        case plain
        case html
        case richtext
        case enriched
        case tabSeparatedValues = "tab-separated-values"
    }

    public let headears: [String : String]
    public let subType: SubTypes
    public let id: String?
    public let charset: Charset?
    public let transferEncoding: ContentTransferEncoding?
    public let name: String?
    public let rawData: String

    public var type: ContentType {
        return .text
    }

    public var text: String? {
        switch transferEncoding {
        case .base64:
            let data = Data(base64Encoded: self.rawData, options: .ignoreUnknownCharacters)
            return data.flatMap { String.init(data: $0, encoding:.utf8) }
        default:
            return nil
        }
    }

    public var description: String {
        return [
            "Content-Type: \(self.type.rawValue)/\(self.subType.rawValue)",
            self.generalDescription
        ].joined(separator: "\n")
    }
}
