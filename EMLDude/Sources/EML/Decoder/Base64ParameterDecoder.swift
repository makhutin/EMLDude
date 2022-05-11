//
//  base64ParameterDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

internal final class Base64ParameterDecoder {
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
        return base64.base64decode ?? ""
    }
}
