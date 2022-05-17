//
//  DateEncoderTests.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 17.05.2022.
//

import Foundation

import XCTest
@testable import EMLDude

internal final class DateEncoderTests: XCTestCase {
    func testShouldCorrectEncode() {
        func test(dateText: String, expectedInput: String) {
            let mockContent = MockContent(type: .message)
            let mockFormatter = MockDateFormatter()

            let resultDate = Date(timeIntervalSince1970: 100)
            mockFormatter.result = resultDate
            mockContent.headears = ["Date": dateText]

            let encoder = DateEncoder(dateFormatter: mockFormatter)
            let date = encoder.date(from: mockContent)

            XCTAssertEqual(resultDate, date)
            XCTAssertEqual(mockFormatter.input, expectedInput)
        }

        test(dateText: "Fri, 3 Dec 2021 05:53:05 +0000", expectedInput: "3 Dec 2021 05:53:05 +0000")
        test(dateText: "5 Dec 2022 05:53:05 +0000", expectedInput: "5 Dec 2022 05:53:05 +0000")
    }
}

extension DateEncoderTests {
    final class MockDateFormatter: DateFormatting {
        var input: String?
        var result: Date?

        func date(from string: String) -> Date? {
            self.input = string
            return result
        }
    }
}
