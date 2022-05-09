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
    public let rawData: String
    public var info: ContentInfo

    public var type: ContentType {
        return .image
    }

    public var description: String {
        return [
            "Content-Type: \(self.type.rawValue)/\(self.subType.rawValue)",
            self.info.description
        ].joined(separator: "\n")
    }
}
