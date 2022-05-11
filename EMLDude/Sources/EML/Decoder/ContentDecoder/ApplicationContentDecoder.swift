//
//  ApplicationContentDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 08.05.2022.
//

import Foundation

internal final class ApplicationContentDecoder: ContentDecoding {
    func content(contentType: ContentTypeModel, headers: [String : String], rawData: String) -> Content? {
        guard let subType = ApplicationContent.SubTypes(rawValue: contentType.subType) else { return nil }

        let info = ContentInfo(headers: headers, contentType: contentType)
        return ApplicationContent(headears: headers, subType: subType, rawData: rawData.withoutCarriage, info: info)
    }
}
