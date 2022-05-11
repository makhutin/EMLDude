//
//  LineDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal protocol LineDecoding {
    func line(line: String) -> LineModel
}

enum LineModel {
    case key(key: String, data: String)
    case data(String)
}

internal final class LineDecoder: LineDecoding {
    private enum Constants {
        static let keySeparator = ": "
    }

    func line(line: String) -> LineModel {
        let components = line.components(separatedBy: Constants.keySeparator)
        if let key = components.first,
           self.checkIsKey(key: key, line: line) {
            let data = line.getPostfixIfPrefix(isEqual: key + Constants.keySeparator) ?? ""
            return .key(key: key, data: data)
        }

        return .data(line)
    }

    private func checkIsKey(key: String, line: String) -> Bool {
        return key.rangeOfCharacter(from: .whitespaces) == nil
            && line.contains(Constants.keySeparator)
            && key.rangeOfCharacter(from: CharacterSet(charactersIn: "\"\'")) == nil
    }
}
