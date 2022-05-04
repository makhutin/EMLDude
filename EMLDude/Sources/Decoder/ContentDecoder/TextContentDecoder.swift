//
//  TextContentDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal final class TextContentDecoder: ContentDecoding {
    func content(contentType: ContentTypeModel,
               headers: [String: String],
               components: [String]) -> Content? {
        guard let subType = TextContent.SubTypes(rawValue: contentType.subType) else { return nil }

        let transeferEncoding = headers[ContentKeys.transferEncoding.rawValue].flatMap { ContentTransferEncoding(rawValue: $0) }
        return TextContent(headears: headers,
                           subType: subType,
                           id: headers[ContentKeys.id.rawValue],
                           charset: contentType.charset,
                           transferEncoding: transeferEncoding,
                           rawData: components.joined())
    }
}
