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

    func content(contentType: ContentTypeModel,
               headers: [String: String],
               components: [String]) -> Content? {
        guard components.count > 1,
              let subType = MultipartContent.SubTypes(rawValue: contentType.subType) else { return nil }

        assert(self.mainDecoder != nil, "Main decoder should be exist")

        return MultipartContent(subType: subType,
                                id: headers[ContentKeys.id.rawValue],
                                charset: contentType.charset,
                                transferEncoding: nil,
                                contents: self.contents(from: components, boundary: contentType.boundary))
    }

    private func contents(from components: [String], boundary: Boundary?) -> [Content] {
        var contents = [Content]()
        guard let parts = self.boundaryDecoder.parts(from: components, boundary: boundary) else { return [] }
        for part in parts {
            let content = self.mainDecoder?.content(components: part)
            content.map { contents.append($0) }
        }
        return contents
    }
}
