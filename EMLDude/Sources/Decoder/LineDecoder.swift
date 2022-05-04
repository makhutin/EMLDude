//
//  LineDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal protocol LineDecoding {
    func line(line: String, mode: LineMode) -> LineModel
}

enum LineModel {
    case key(key: String, data: String, originalLine: String)
    case data(String)
    case boundary(position: BoundaryPosition)
    case carriage(String)
}

enum LineMode {
    case boundary(boundary: Boundary?)
    case easy
}

internal final class LineDecoder: LineDecoding {
    private enum Constants {
        static let keySeparator = ": "
        static let carriage = "\r"
    }

    func line(line: String, mode: LineMode) -> LineModel {
        switch mode {
        case .boundary(let boundary):
            if let model = self.findBoundary(line: line, boundary: boundary) {
                return model
            }
            fallthrough
        case .easy:
            return self.easyLine(line: line)
        }
    }

    private func easyLine(line: String) -> LineModel {
        let components = line.components(separatedBy: Constants.keySeparator)
        if let key = components.first,
           self.checkIsKey(key: key, line: line) {
            let data = line.getPostfixIfPrefix(isEqual: key + Constants.keySeparator) ?? ""
            return .key(key: key, data: data, originalLine: line)

        } else if self.checkIsCarriageOrEmpty(line: line) {
            return .carriage(line)
        }

        return .data(line)
    }

    private func findBoundary(line: String, boundary: Boundary?) -> LineModel? {
        if let boundary = boundary {
            switch line.replacingOccurrences(of: Constants.carriage, with: "") {
            case boundary.middle:
                return .boundary(position: .middle)
            case boundary.end:
                return .boundary(position: .end)
            default:
                return nil
            }
        }
        return nil
    }

    private func checkIsCarriageOrEmpty(line: String) -> Bool {
        return line == Constants.carriage || line.isEmpty
    }

    private func checkIsKey(key: String, line: String) -> Bool {
        return key.rangeOfCharacter(from: .whitespaces) == nil
            && line.contains(Constants.keySeparator)
            && key.rangeOfCharacter(from: CharacterSet(charactersIn: "\"\'")) == nil
    }
}
