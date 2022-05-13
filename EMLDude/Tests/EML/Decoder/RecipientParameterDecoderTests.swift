//
//  RecipientParameterDecoderTests.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 13.05.2022.
//

import Foundation

import XCTest
@testable import EMLDude

internal final class RecipientParameterDecoderTests: XCTestCase {
    func testShouldDecodeOnlyMail() {
        let base64decoder = MockBase64ParameterDecoder()
        let decoder = RecipientParameterDecoder(base64Decoder: base64decoder)

        let testData = [
            "\"foo@bar.baz\"",
            "some random string",
            "<OnlyMail@value.com>",
            "<OnlyMail@value.com>,\n\r \"some@other.mail",
            "some first, \n\r some second"
        ]
        let checkData = [
            ["foo@bar.baz"],
            ["some random string"],
            ["OnlyMail@value.com"],
            ["OnlyMail@value.com", "some@other.mail"],
            ["some first", "some second"]
        ]
        zip(testData, checkData).forEach { (test, check) in
            let result = decoder.recipients(from: test)

            zip(result, check).forEach { (result, check) in
                switch result {
                case .email(let email):
                    XCTAssertEqual(email, check)
                default:
                    XCTFail()
                }
            }

            XCTAssertTrue(base64decoder.parameters.isEmpty)
        }
    }

    func testShouldDecodeEmailWithNames() {
        let base64decoder = MockBase64ParameterDecoder()
        let decoder = RecipientParameterDecoder(base64Decoder: base64decoder)

        let testData = [
            "\"foo@bar.baz\"     <OnlyMail@value.com>",
            "some random string \n\r    <OnlyMail@value.com>",
            "first name <first@mail.com>, \r\n\r\n secondName <second@mail.com>,,, third<third@mail.com>,"
        ]
        let checkData = [
            [("foo@bar.baz", "OnlyMail@value.com")],
            [("some random string", "OnlyMail@value.com")],
            [("first name", "first@mail.com"), ("secondName", "second@mail.com"), ("third", "third@mail.com")]
        ]

        zip(testData, checkData).forEach { (test, check) in
            base64decoder.parameters = []
            let result = decoder.recipients(from: test)

            zip(result, check).forEach { (result, checkTuple) in
                switch result {
                case .full(let name, let email):
                    XCTAssertEqual(name, checkTuple.0)
                    XCTAssertEqual(email, checkTuple.1)
                default:
                    XCTFail()
                }
            }

            XCTAssertEqual(base64decoder.parameters.count, check.count)
            zip(base64decoder.parameters, check).forEach { (parameter, check) in
                XCTAssertTrue(parameter.contains(check.0))
            }
        }
    }

    func testShouldDecodeReturnNameFromBase64() {
        let base64decoder = MockBase64ParameterDecoder()
        let decoder = RecipientParameterDecoder(base64Decoder: base64decoder)

        let testData = "shouldNorReturnThisName <some@mail.com>"
        let checkData = "shouldReturnThisName"
        base64decoder.result = checkData

        let result = decoder.recipients(from: testData)
        switch result.first {
        case .full(let name, _):
            XCTAssertEqual(name, checkData)
        default:
            XCTFail()
        }
    }
}
