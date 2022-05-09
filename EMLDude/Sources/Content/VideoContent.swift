//
//  VideoContent.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

public struct VideoContent: Content {
    public enum SubTypes: String {
        case quicktime
        case mpeg
        case mp4
    }

    public var headears: [String : String]
    public let subType: SubTypes
    public let rawData: String
    public let info: ContentInfo

    public var type: ContentType {
        return .video
    }

    public var description: String {
        return [
            "Content-Type: \(self.type.rawValue)/\(self.subType.rawValue)",
            self.info.description
        ].joined(separator: "\n")
    }
}
