//
//  ContentInfo.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 09.05.2022.
//

import Foundation

public struct ContentInfo: CustomStringConvertible {
    public let id: String?
    public let charset: Charset?
    public let transferEncoding: ContentTransferEncoding?
    public let name: String?

    public var description: String {
        return [
            "id: \(String(describing: self.id))",
            "charset: \(String(describing: self.charset?.rawValue))",
            "transferEncoding: \(String(describing: self.transferEncoding?.rawValue))",
            "name: \(String(describing: self.name))"
        ].joined(separator: "\n")
    }

    init(headers: [String: String], contentType: ContentTypeModel) {
        self.init(id: headers[ContentKeys.id.rawValue],
                  charset: contentType.charset,
                  transferEncoding: headers[ContentKeys.transferEncoding.rawValue].flatMap { ContentTransferEncoding(rawValue: $0) },
                  name: contentType.name)
    }

    public init(id: String? = nil,
                charset: Charset? = nil,
                transferEncoding: ContentTransferEncoding? = nil,
                name: String? = nil) {
        self.id = id
        self.charset = charset
        self.transferEncoding = transferEncoding
        self.name = name
    }
}
