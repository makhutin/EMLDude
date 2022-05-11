//
//  AudioContentDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 09.05.2022.
//

import UIKit

internal final class AudioContentDecoder: ContentDecoding {
    func content(contentType: ContentTypeModel, headers: [String : String], rawData: String) -> Content? {
        guard let subType = AudioContent.SubTypes(rawValue: contentType.subType) else { return nil }

        let info = ContentInfo(headers: headers, contentType: contentType)
        return AudioContent(headears: headers, subType: subType, rawData: rawData.withoutCarriage, info: info)
    }
}
