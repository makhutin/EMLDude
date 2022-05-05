//
//  HeaderDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal struct HeaderModel {
    let headers: [String: String]
    let rawData: String
}

internal protocol HeaderDecoding {
    func header(rawData: String) -> HeaderModel?
}

internal final class HeaderDecoder: HeaderDecoding {
    private enum Constants {
        static let headerSeporator = "\r\r"
        static let lineSeporator = "\r"
    }
    private let lineDecoder: LineDecoding

    init(line: LineDecoding) {
        self.lineDecoder = line
    }

    func header(rawData: String) -> HeaderModel? {
        var components = rawData.components(separatedBy: Constants.headerSeporator)
        let headerLines = components.popFirts()?.components(separatedBy: Constants.lineSeporator)

        var headers = [String: String]()
        var buffer: String?
        var key: String?

        for rawLine in headerLines ?? [] {
            let line = self.lineDecoder.line(line: rawLine)
            switch line {
            case .data(let newData):
                buffer = (buffer ?? "") + newData
            case .key(let newKey, let newData):
                key.map { headers[$0] = buffer?.withoutCarriage }
                key = newKey
                buffer = newData
            }
        }

        key.map { headers[$0] = buffer?.withoutCarriage }
        return HeaderModel(headers: headers, rawData: components.joined(separator: Constants.headerSeporator))
    }
}
