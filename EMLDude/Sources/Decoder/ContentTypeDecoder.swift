//
//  ContentTypeDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal struct ContentTypeModel {
    let type: ContentType
    let subType: String
    let charset: Charset?
    let boundary: Boundary?
}

internal protocol ContentTypeDecoding {
    func contentType(headers: [String: String]) -> ContentTypeModel?
}

internal final class ContentTypeDecoder: ContentTypeDecoding {
    private enum Constants {
        static let contentType = "Content-Type"
        static let typeSeporator = "/"
        static let infoTypeSeporator = ";"
        static let charsetPrefix = "charset="
    }

    func contentType(headers: [String: String]) -> ContentTypeModel? {
        guard let data = headers[Constants.contentType] else { return nil }
        
        let allComponents = data
            .removeCharacters(charactersSet: .whitespaces)
            .components(separatedBy: Constants.infoTypeSeporator)

        let typeData = allComponents
            .first?
            .components(separatedBy: Constants.typeSeporator) ?? []

        guard typeData.count == 2,
              let type = ContentType(rawValue: typeData.first ?? .empty),
              let subType = typeData.last else { return nil }

        var charset: Charset?
        var boundary: Boundary?
        allComponents.forEach { component in
            if let rawCharset = component.lowercased().getPostfixIfPrefix(isEqual: Constants.charsetPrefix) {
                charset = Charset(rawValue: rawCharset)
            }
            boundary = Boundary(rawLine: component) ?? boundary
        }

        return ContentTypeModel(type: type, subType: subType, charset: charset, boundary: boundary)
    }
}
