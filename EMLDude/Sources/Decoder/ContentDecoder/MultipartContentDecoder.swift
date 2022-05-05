//
//  MultipartContentDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal final class MultipartContentDecoder: ContentDecoding {
    weak var mainDecoder: MainDecoder?
    private let boundaryDecoder: BoundaryPartsDecoder

    init(boundary: BoundaryPartsDecoder) {
        self.boundaryDecoder = boundary
    }

    func content(contentType: ContentTypeModel, headers: [String : String], rawData: String) -> Content? {
        guard let subType = MultipartContent.SubTypes(rawValue: contentType.subType),
              let boundary = contentType.boundary else { return nil }

        assert(self.mainDecoder != nil, "Main decoder should be exist")

        return MultipartContent(headears: headers,
                                subType: subType,
                                id: headers[ContentKeys.id.rawValue],
                                charset: contentType.charset,
                                transferEncoding: nil,
                                contents: self.contents(from: rawData, boundary: boundary))
    }

    private func contents(from rawData: String, boundary: Boundary) -> [Content] {
        var contents = [Content]()
        guard let parts = self.boundaryDecoder.parts(from: rawData, boundary: boundary) else { return [] }
        for part in parts {
            let content = self.mainDecoder?.content(rawData: part)
            content.map { contents.append($0) }
        }
        return contents
    }
}
