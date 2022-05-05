//
//  MainDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal final class MainDecoder {
    private let mainContentDecoder: MainContentDecoding
    private let headerDecoder: HeaderDecoding

    init(mainContent: MainContentDecoding, header: HeaderDecoding) {
        self.mainContentDecoder = mainContent
        self.headerDecoder = header
    }

    func content(from data: Data) throws -> Content? {
        let rawData = try self.rawData(from: data)
        let content = self.content(rawData: rawData)
        return content
    }

    func content(rawData: String) -> Content? {
        guard let headerModel = self.headerDecoder.header(rawData: rawData),
              let content = self.mainContentDecoder.content(headers: headerModel.headers, rawData: headerModel.rawData) else { return nil }

        return content
    }

    private func rawData(from data: Data) throws -> String {
        if let dataText = String(data: data, encoding: .utf8) {
            return dataText.removeNewLines
        } else {
            throw EMLDudeError.cantDecodeData
        }
    }
}

private extension String {
    var removeNewLines: String {
        return self.replacingOccurrences(of: "\n", with: "")
    }
}
