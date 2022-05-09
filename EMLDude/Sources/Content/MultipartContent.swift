//
//  MultipartContent.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

public struct MultipartContent: Content {
    public enum SubTypes: String {
        case mixed
        case alternative
        case digest
        case parallel
        case related
        case other // https://www.opennet.ru/docs/RUS/mime_rfc/ for other types need use mixed
    }

    public let headears: [String : String]
    public let subType: SubTypes
    public let contents: [Content]
    public var rawData: String
    public var info: ContentInfo

    public var type: ContentType {
        return .multipart
    }
}

extension MultipartContent: CustomStringConvertible {
    public var description: String {
        return [
            "Content-Type: multipart/\(self.subType)",
            self.info.description,
            self.contentDescription
        ].joined(separator: "\n")
    }

    private var contentDescription: String {
        "Contents: \n" + self.contents
            .compactMap { $0.description
                .components(separatedBy: .newlines)
                .map{ "           " + $0 }
                .joined(separator: "\n") }
            .joined(separator: ",\n\n")
    }
}
