//
//  Base64ParameterDecoderTests.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 13.05.2022.
//

import Foundation

import XCTest
@testable import EMLDude

internal final class Base64ParameterDecoderTests: XCTestCase {
    func testShouldDecode() {
        let testParameters = [
            "=?UTF-8?B?Rm9vQmFyQmF6?=",
            "=?utf-8?B?Rm9vQmFyQmF6?=",
            "=?utf-8?B?SXRJc1NvbWVUZXN0?=",
            "=?utf-8?B?Rmlyc3RQYXJ0T2ZTdHJhbmdlVGVzdA==?= \n\r,;otherSymbols =?utf-8?B?c2Vjb25kUGFydE9mU3RyYW5nZVRlc3Q=?="
        ]
        let checkParameters = [
            "FooBarBaz",
            "FooBarBaz",
            "ItIsSomeTest",
            "FirstPartOfStrangeTestsecondPartOfStrangeTest"
        ]
        let decoder = Base64ParameterDecoder()
        zip(testParameters, checkParameters).forEach { (test, check) in
            let result = decoder.decodeIfNeeded(parameter: test)
            XCTAssertEqual(result, check)
        }
    }

    func testShouldNotDecode() {
        let testParameters = [
            "=TF-8?B?Rm9vQmFyQmF6?=",
            "ItIsSomeTest",
            "=?utf-8?B?SXRJc1NvbWVUZXN0",
            "SXRJc1NvbWVUZXN0?="
        ]
        let decoder = Base64ParameterDecoder()
        testParameters.forEach { test in
            let result = decoder.decodeIfNeeded(parameter: test)
            XCTAssertEqual(result, test)
        }
    }
}
