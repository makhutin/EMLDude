//
//  MainContentDecoderTests.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 02.05.2022.
//

import Foundation

import XCTest
@testable import EMLDude

internal final class MainContentDecoderTests: XCTestCase {
    func testShouldUseCorrectDecoder() {
        [ContentType.multipart, .image, .text].forEach { type in
            let multipart = MockContentDecoder(type: .multipart)
            let image = MockContentDecoder(type: .image)
            let text = MockContentDecoder(type: .text)
            let contentTypeDecoder = MockContentTypeDecoder()

            let subtype = "Test"
            let charset = Charset.iso88591
            contentTypeDecoder.model = ContentTypeModel(type: type, subType: subtype, charset: charset, boundary: nil)

            let contentDecoder = MainContentDecoder(multipart: multipart,
                                                    image: image,
                                                    text: text,
                                                    contentType: contentTypeDecoder)
            let checkHeaders = ["check": "headers"]
            let checkComponents = ["checkComponents"]
            var decoder: MockContentDecoder?

            switch type {
            case .multipart:
                decoder = multipart
            case .image:
                decoder = image
            case .text:
                decoder = text
            default:
                XCTFail()
            }

            decoder?.content = MockContent(type: type)
            let content = contentDecoder.content(headers: checkHeaders, components: checkComponents)

            XCTAssertEqual(contentTypeDecoder.headers, checkHeaders)

            XCTAssertNotNil(decoder)

            XCTAssertEqual(decoder?.type, type)
            XCTAssertEqual(decoder?.headers, checkHeaders)
            XCTAssertEqual(decoder?.components, checkComponents)
            XCTAssertNotNil(content)
        }
    }
}

extension MainContentDecoderTests {
    final class MockContentDecoder: ContentDecoding {
        var type: ContentType
        var content: Content?
        var headers: [String: String] = [:]
        var components: [String] = []

        init(type: ContentType) {
            self.type = type
        }

        func content(contentType: ContentTypeModel, headers: [String : String], components: [String]) -> Content? {
            self.headers = headers
            self.components = components
            XCTAssertEqual(self.type, contentType.type)
            return self.content
        }
    }

    final class MockContentTypeDecoder: ContentTypeDecoding {
        var headers: [String: String]?
        var model: ContentTypeModel?

        func contentType(headers: [String : String]) -> ContentTypeModel? {
            self.headers = headers
            return model
        }
    }
}
