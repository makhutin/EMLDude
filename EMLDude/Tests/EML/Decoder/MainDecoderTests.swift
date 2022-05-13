//
//  MainDecoderTests.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 02.05.2022.
//

import Foundation

import XCTest
@testable import EMLDude

internal final class MainDecoderTests: XCTestCase {
    func testShouldCorrectWork() {
        let mainContentDecoder = MockMainContentDecoder()
        let headerContentDecoder = MockHeaderDecoder()

        let checkRawData = "CheckRawData"
        let checkHeaders = ["Check": "Headers"]
        let headerModel = HeaderModel(headers: checkHeaders, rawData: checkRawData)
        headerContentDecoder.model = headerModel

        let mockContent = MockContent(type: .image)
        mainContentDecoder.content = mockContent

        let mainDecoder = MainDecoder(mainContent: mainContentDecoder, header: headerContentDecoder)
        let content = mainDecoder.content(rawData: checkRawData)

        XCTAssertEqual(content?.type, mockContent.type)

        XCTAssertEqual(mainContentDecoder.rawData, checkRawData)
        XCTAssertEqual(mainContentDecoder.headers, checkHeaders)

        XCTAssertEqual(headerContentDecoder.rawData, checkRawData)

        XCTAssertEqual(headerContentDecoder.rawData, checkRawData)
    }
}

extension MainDecoderTests {
    final class MockHeaderDecoder: HeaderDecoding {
        var rawData: String?
        var model: HeaderModel?

        func header(rawData: String) -> HeaderModel? {
            self.rawData = rawData
            return self.model
        }
    }

    final class MockMainContentDecoder: MainContentDecoding {
        var headers: [String: String]?
        var rawData: String?
        var content: Content?

        func content(headers: [String : String], rawData: String) -> Content? {
            self.headers = headers
            self.rawData = rawData
            return content
        }
    }
}
