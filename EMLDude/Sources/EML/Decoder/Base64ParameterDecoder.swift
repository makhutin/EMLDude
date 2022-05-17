//
//  base64ParameterDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

internal protocol Base64ParameterDecoding {
    func decodeIfNeeded(parameter: String) -> String
}

internal final class Base64ParameterDecoder: Base64ParameterDecoding {
    private enum Constants {
        static let base64preamble = "=?UTF-8?B?"
        static let base64postPreamble = "?="
    }

    func decodeIfNeeded(parameter: String) -> String {
        var result = [String]()
        var preambleRange = parameter.range(of: Constants.base64preamble, options: .caseInsensitive)
        var postPreambleRange = preambleRange.flatMap { parameter.range(of: Constants.base64postPreamble, range: $0.upperBound..<parameter.endIndex) }

        while let localPreambleRange = preambleRange,
              let localPostPreambleRange = postPreambleRange {

            result.append(self.decodeSubSequence(slice: parameter[localPreambleRange.upperBound..<localPostPreambleRange.lowerBound]))

            preambleRange = parameter.range(of: Constants.base64preamble, options: .caseInsensitive, range: localPreambleRange.upperBound..<parameter.endIndex)
            postPreambleRange = preambleRange.flatMap { parameter.range(of: Constants.base64postPreamble, range: $0.upperBound..<parameter.endIndex) }
        }
        return result.isEmpty ? parameter : result.joined()
    }

    func decodeSubSequence(slice: String.SubSequence) -> String {
        let result = String(slice).base64decode ?? ""
        let lastIndex = result.lastIndex { $0 != "\0".first } ?? result.endIndex
        return String(result[...lastIndex])
    }
}
