//
//  ImageContentDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal final class ImageContentDecoder: ContentDecoding {
    func content(contentType: ContentTypeModel, headers: [String : String], rawData: String) -> Content? {
        guard shouldStartDecoding(with: contentType.subType),
              let subType = ImageContent.SubTypes(rawValue: contentType.subType) else { return nil }


        let info = ContentInfo(headers: headers, contentType: contentType)
        return ImageContent(headears: headers, subType: subType, rawData: rawData, info: info)
    }

    private func shouldStartDecoding(with subType: String) -> Bool {
        let subType = ImageContent.SubTypes(rawValue: subType)
        return subType != nil
    }
}
