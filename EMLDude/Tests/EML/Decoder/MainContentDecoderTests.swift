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
        [ContentType.multipart, .image, .video, .audio, .text, .message, .application].forEach { type in
            let multipart = MockContentDecoder(type: .multipart)
            let image = MockContentDecoder(type: .image)
            let video = MockContentDecoder(type: .video)
            let audio = MockContentDecoder(type: .audio)
            let text = MockContentDecoder(type: .text)
            let message = MockContentDecoder(type: .message)
            let application = MockContentDecoder(type: .application)
            let contentTypeDecoder = MockContentTypeDecoder()

            let subtype = "Test"
            let charset = Charset.iso88591
            contentTypeDecoder.model = ContentTypeModel(type: type, subType: subtype, charset: charset, boundary: nil, name: nil)

            let contentDecoder = MainContentDecoder(multipart: multipart,
                                                    image: image,
                                                    video: video,
                                                    audio: audio,
                                                    text: text,
                                                    message: message,
                                                    application: application,
                                                    contentType: contentTypeDecoder)
            let checkHeaders = ["check": "headers"]
            let checkRawData = "checkRawData"
            var decoder: MockContentDecoder?

            switch type {
            case .multipart:
                decoder = multipart
            case .image:
                decoder = image
            case .video:
                decoder = video
            case .text:
                decoder = text
            case .application:
                decoder = application
            case .message:
                decoder = message
            case .audio:
                decoder = audio
            }

            decoder?.content = MockContent(type: type)
            let content = contentDecoder.content(headers: checkHeaders, rawData: checkRawData)

            XCTAssertEqual(contentTypeDecoder.headers, checkHeaders)

            XCTAssertNotNil(decoder)

            XCTAssertEqual(decoder?.type, type)
            XCTAssertEqual(decoder?.headers, checkHeaders)
            XCTAssertEqual(decoder?.rawData, checkRawData)
            XCTAssertNotNil(content)
        }
    }
}

extension MainContentDecoderTests {
    final class MockContentDecoder: ContentDecoding {
        var type: ContentType
        var content: Content?
        var headers: [String: String] = [:]
        var rawData: String?

        init(type: ContentType) {
            self.type = type
        }

        func content(contentType: ContentTypeModel, headers: [String : String], rawData: String) -> Content? {
            self.headers = headers
            self.rawData = rawData
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
