//
//  ImageContent.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

public struct ImageContent: Content {
    public enum SubTypes: String {
        case gif
        case jpeg
        case png
    }

    public let headears: [String : String]
    public let subType: SubTypes
    public let id: String?
    public let charset: Charset?
    public let transferEncoding: ContentTransferEncoding?
    public let name: String?
    public let rawData: String

    public var type: ContentType {
        return .image
    }

    public var description: String {
        return [
            "Content-Type: \(self.type.rawValue)/\(self.subType.rawValue)",
            self.generalDescription
        ].joined(separator: "\n")
    }
}
