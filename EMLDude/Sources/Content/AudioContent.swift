//
//  AudioContent.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

public struct AudioContent: Content {
    public enum SubTypes: String {
        case basic
    }

    public var headears: [String : String]
    public let subType: SubTypes
    public var rawData: String
    public var info: ContentInfo

    public var type: ContentType {
        return .audio
    }

    public var description: String {
        return [
            "Content-Type: \(self.type.rawValue)/\(self.subType)",
            self.info.description
        ].joined(separator: "\n")
    }
}
