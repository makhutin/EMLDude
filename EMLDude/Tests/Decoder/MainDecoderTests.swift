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

        let checkComponents = ["CheckComponents"]
        let checkHeaders = ["Check": "Headers"]
        let headerModel = HeaderModel(headers: checkHeaders, components: checkComponents)
        headerContentDecoder.model = headerModel

        let mockContent = MockContent(type: .image)
        mainContentDecoder.content = mockContent

        let mainDecoder = MainDecoder(mainContent: mainContentDecoder, header: headerContentDecoder)
        let content = mainDecoder.content(components: checkComponents)

        XCTAssertEqual(content?.type, mockContent.type)

        XCTAssertEqual(mainContentDecoder.components, checkComponents)
        XCTAssertEqual(mainContentDecoder.headers, checkHeaders)

        XCTAssertEqual(headerContentDecoder.components, checkComponents)

        XCTAssertEqual(headerContentDecoder.components, checkComponents)
    }
}

extension MainDecoderTests {
    final class MockHeaderDecoder: HeaderDecoding {
        var components: [String]?
        var model: HeaderModel?

        func header(components: [String]) -> HeaderModel? {
            self.components = components
            return self.model
        }
    }

    final class MockMainContentDecoder: MainContentDecoding {
        var headers: [String: String]?
        var components: [String]?
        var content: Content?

        func content(headers: [String : String], components: [String]) -> Content? {
            self.headers = headers
            self.components = components
            return content
        }
    }
}
