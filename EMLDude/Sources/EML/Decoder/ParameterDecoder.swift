//
//  ParameterDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 08.05.2022.
//

import Foundation

internal enum ParameterModel {
    case single(some: String)
    case keyValue(key: String, value: String)
}

internal protocol ParameterDecoding {
    func parameters(data: String) -> [ParameterModel]
}

internal final class ParameterDecoder: ParameterDecoding {
    enum Constants {
        static let parametersSeparator = ";"
        static let keyValueSeparator = "="
    }

    func parameters(data: String) -> [ParameterModel] {
        var result = [ParameterModel]()
        let components = data.components(separatedBy: CharacterSet(charactersIn: Constants.parametersSeparator))
        for component in components {
            guard let firstParamSymbol = component.firstIndex(where: { !$0.isWhitespace && !$0.isNewline }) else { continue }
            let rawParameter = component[firstParamSymbol...]
            result.append(self.parameter(from: rawParameter))
        }
        return result
    }

    private func parameter(from parameter: String.SubSequence) -> ParameterModel {
        let parameters = parameter.components(separatedBy: Constants.keyValueSeparator)
        if parameters.count > 1,
           let key = parameters.first {
            let value = parameters[1...].joined(separator: Constants.keyValueSeparator)
            return .keyValue(key: key, value: value.withoutQuotes)
        } else {
            return .single(some: String(parameter))
        }
    }
}
