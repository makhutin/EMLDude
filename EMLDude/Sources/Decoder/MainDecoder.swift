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
        let components = try self.components(from: data)
        return self.content(components: components)
    }

    func content(components: [String]) -> Content? {
        guard let headerModel = self.headerDecoder.header(components: components),
              let content = self.mainContentDecoder.content(headers: headerModel.headers, components: headerModel.components) else {
            return nil
        }
        return content
    }

    private func components(from data: Data) throws -> [String] {
        if let dataText = String(data: data, encoding: .utf8) {
            let components = dataText.components(separatedBy: "\n")
            return components

        } else {
            throw EMLDudeError.cantDecodeData
        }
    }
}
