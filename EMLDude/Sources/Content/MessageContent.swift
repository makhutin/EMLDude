//
//  MessageContent.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

public struct MessageContent: Content {
    public enum SubTypes: String {
        case rfc822 // main
        case partial
        case externalBody = "external-body"
        case news
    }

    public var headears: [String : String]
    public let subType: SubTypes
    public var rawData: String
    public var info: ContentInfo

    public var type: ContentType {
        return .message
    }

    public var description: String {
        return [
            "Content-Type: \(self.type.rawValue)/\(self.subType.rawValue)",
            self.info.description
        ].joined(separator: "\n")
    }
}
