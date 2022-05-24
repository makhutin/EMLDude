//
//  TextContentDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal final class TextContentDecoder: ContentDecoding {
    func content(contentType: ContentTypeModel, headers: [String : String], rawData: String) -> Content? {
        guard let subType = TextContent.SubTypes(rawValue: contentType.subType) else { return nil }

        let info = ContentInfo(headers: headers, contentType: contentType)
        return TextContent(headears: headers, subType: subType, rawData: rawData, info: info)
    }
}
