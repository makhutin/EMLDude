//
//  MessageContentDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 09.05.2022.
//

import Foundation

internal final class MessageContentDecoder: ContentDecoding {
    func content(contentType: ContentTypeModel, headers: [String : String], rawData: String) -> Content? {
        guard let subType = MessageContent.SubTypes(rawValue: contentType.subType) else { return nil }

        let info = ContentInfo(headers: headers, contentType: contentType)
        return MessageContent(headears: headers, subType: subType, rawData: rawData.withoutCarriage, info: info)
    }
}
