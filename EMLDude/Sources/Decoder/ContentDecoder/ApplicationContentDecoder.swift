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

        let transeferEncoding = headers[ContentKeys.transferEncoding.rawValue].flatMap { ContentTransferEncoding(rawValue: $0) }

        return ApplicationContent(headears: headers,
                                  subType: subType,
                                  id: headers[ContentKeys.id.rawValue],
                                  charset: contentType.charset,
                                  transferEncoding: transeferEncoding,
                                  name: contentType.name,
                                  rawData: rawData.withoutCarriage)
    }
}
