//
//  ImageContentDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal final class ImageContentDecoder: ContentDecoding {
    func content(contentType: ContentTypeModel,
               headers: [String: String],
               components: [String]) -> Content? {
        guard shouldStartDecoding(with: contentType.subType),
              let subType = ImageContent.SubTypes(rawValue: contentType.subType) else { return nil }


        let transeferEncoding = headers[ContentKeys.transferEncoding.rawValue].flatMap { ContentTransferEncoding(rawValue: $0) }
        return ImageContent(headears: headers,
                            subType: subType,
                            id: headers[ContentKeys.id.rawValue],
                            charset: contentType.charset,
                            transferEncoding: transeferEncoding,
                            rawData: components.joined())
    }

    private func shouldStartDecoding(with subType: String) -> Bool {
        let subType = ImageContent.SubTypes(rawValue: subType)
        return subType != nil
    }
}
