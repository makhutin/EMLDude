//
//  ContentDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 30.04.2022.
//

import Foundation

internal protocol ContentDecoding {
    func content(contentType: ContentTypeModel,
                 headers: [String: String],
                 rawData: String) -> Content?
}

internal protocol MainContentDecoding {
    func content(headers: [String: String],
                 rawData: String) -> Content?
}

internal final class MainContentDecoder: MainContentDecoding {
    private let multipart: ContentDecoding
    private let image: ContentDecoding
    private let text: ContentDecoding
    private let contentType: ContentTypeDecoding

    init(multipart: ContentDecoding,
         image: ContentDecoding,
         text: ContentDecoding,
         contentType: ContentTypeDecoding) {
        self.multipart = multipart
        self.image = image
        self.text = text
        self.contentType = contentType
    }

    func content(headers: [String : String], rawData: String) -> Content? {
        guard let contentModel = self.contentType.contentType(headers: headers) else { return nil }

        let decoder = self.decoder(by: contentModel)
        return decoder?.content(contentType: contentModel, headers: headers, rawData: rawData)
    }

    private func decoder(by contentType: ContentTypeModel) -> ContentDecoding? {
        switch contentType.type {
        case .multipart:
            return self.multipart
        case .text:
            return self.text
        case .image:
            return self.image
        default:
            return nil
        }
    }
}
