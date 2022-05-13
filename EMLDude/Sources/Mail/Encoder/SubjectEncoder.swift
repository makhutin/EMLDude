//
//  SubjectEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 13.05.2022.
//

import Foundation

internal final class SubjectEncoder {
    private enum Constants {
        static let subjectKey = "Subject"
    }
    private let base64ParameterDecoder: Base64ParameterDecoding
    init(base64ParameterDecoder: Base64ParameterDecoding) {
        self.base64ParameterDecoder = base64ParameterDecoder
    }

    func subject(from content: Content) -> String? {
        guard let parameter = content.headears[Constants.subjectKey] else { return nil }
        
        return self.base64ParameterDecoder.decodeIfNeeded(parameter: parameter)
    }
}
