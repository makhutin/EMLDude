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
        guard let preambleRange = parameter.range(of: Constants.base64preamble, options: .caseInsensitive),
              let postPreambleRange = parameter.range(of: Constants.base64postPreamble, options: .backwards) else {
            return parameter
        }

        let base64 = String(parameter[preambleRange.upperBound..<postPreambleRange.lowerBound])
        let result = base64.base64decode ?? ""
        let lastIndex = result.lastIndex { $0 != "\0".first } ?? result.endIndex
        return String(result[...lastIndex])
    }
}
