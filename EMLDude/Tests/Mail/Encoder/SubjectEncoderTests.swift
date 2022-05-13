//
//  SubjectEncoderTests.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 13.05.2022.
//

import Foundation

import XCTest
@testable import EMLDude

internal final class SubjectEncoderTests: XCTestCase {
    func testShouldCorrectDecode() {
        let base64ParameterDecoder = MockBase64ParameterDecoder()
        let mockContent = MockContent(type: .message)

        let testResult = "testParameter"
        let checkData = "checkData"
        mockContent.headears = ["Subject": checkData]
        base64ParameterDecoder.result = testResult

        let encoder = SubjectEncoder(base64ParameterDecoder: base64ParameterDecoder)
        let subject = encoder.subject(from: mockContent)

        XCTAssertEqual(testResult, subject)
        XCTAssertEqual(base64ParameterDecoder.parameters.first, checkData)
    }
}
