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

    public let subType: SubTypes
    public let id: String?
    public let charset: Charset?
    public let transferEncoding: ContentTransferEncoding?

    public let contents: [Content]

    public var type: ContentType {
        return .multipart
    }
}

extension MultipartContent: CustomStringConvertible {
    public var description: String {
        let description: [String?] = [
            "Content-Type: multipart/\(self.subType)",
            (self.id != nil ? "Content-ID: \(self.id ?? "")" : nil),
            self.charset != nil ? "Charset: \(self.charset?.rawValue ?? "")" : nil,
            self.transferEncoding != nil ? "Content-Transfer-Encoding: \(self.transferEncoding?.rawValue ?? "")" : nil,
            self.contentDescription
        ]
        return description
            .compactMap{ $0 }
            .joined(separator: "\n")
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
