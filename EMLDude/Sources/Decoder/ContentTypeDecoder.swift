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
    let name: String?
}

internal protocol ContentTypeDecoding {
    func contentType(headers: [String: String]) -> ContentTypeModel?
}

internal final class ContentTypeDecoder: ContentTypeDecoding {
    private enum Constants {
        static let typeSeporator = "/"
        static let charsetKey = "charset"
        static let nameKey = "name"
        static let boundaryKey = "boundary"
    }

    private let parameterDecoder: ParameterDecoding

    init(parameter: ParameterDecoding) {
        self.parameterDecoder = parameter
    }

    func contentType(headers: [String: String]) -> ContentTypeModel? {
        guard let data = headers[ContentKeys.type.rawValue] else { return nil }

        let parameters = self.parameterDecoder.parameters(data: data)
        guard case let .single(typeParameter) = parameters.first else { return nil }

        let typeData = typeParameter.components(separatedBy: Constants.typeSeporator)
        guard typeData.count == 2,
              let type = ContentType(rawValue: typeData.first ?? .empty),
              let subType = typeData.last else { return nil }

        var charset: Charset?
        var boundary: Boundary?
        var name: String?

        for parameter in parameters {
            guard case let .keyValue(key, value) = parameter else { continue }

            switch key {
            case Constants.charsetKey:
                charset = Charset(rawValue: value)
            case Constants.nameKey:
                name = value
            case Constants.boundaryKey:
                boundary = Boundary(name: value)
            default:
                break
            }
        }

        return ContentTypeModel(type: type,
                                subType: subType,
                                charset: charset,
                                boundary: boundary,
                                name: name)
    }
}
