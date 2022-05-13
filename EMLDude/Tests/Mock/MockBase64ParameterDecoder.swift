//
//  MockBase64ParameterDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 13.05.2022.
//

import Foundation
@testable import EMLDude

final class MockBase64ParameterDecoder: Base64ParameterDecoding {
    var parameters = [String]()
    var result: String?

    func decodeIfNeeded(parameter: String) -> String {
        self.parameters.append(parameter)
        return self.result ?? parameter
    }
}
