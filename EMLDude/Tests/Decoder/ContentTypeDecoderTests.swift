//
//  ContentTypeDecoderTests.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import XCTest
@testable import EMLDude

internal final class ContentTypeDecoderTests: XCTestCase {
    func testShouldDecodeTypeCorrect() {
        let contentTypeDecoder = ContentTypeDecoder()
        let key = "Content-Type"
        let types: [ContentType] = [
            .application,
            .audio,
            .image,
            .message,
            .multipart,
            .text,
            .video
        ]

        types.forEach { type in
            let subType = "subType\(type.rawValue)"
            let headers = [key: "\(type.rawValue)/\(subType)"]
            let model = contentTypeDecoder.contentType(headers: headers)
            XCTAssertEqual(type, model?.type)
            XCTAssertEqual(model?.subType, subType)
        }
    }

    func testShouldNotDecodeLine() {
        let contentTypeDecoder = ContentTypeDecoder()
        let headers = ["Other-key": "no need decode"]
        let model = contentTypeDecoder.contentType(headers: headers)
        XCTAssertNil(model)

        let wrongHeaders = ["Content-Type": "wrongType/mp4"]
        let modelSecond = contentTypeDecoder.contentType(headers: wrongHeaders)
        XCTAssertNil(modelSecond)
    }

    func testShouldDecodeCharset() {
        let contentTypeDecoder = ContentTypeDecoder()
        let charsets: [Charset] = [
            .iso88591,
            .usAscii,
            .utf8
        ]

        charsets.forEach { charset in
            let key = "Content-Type"
            let data = "text/other;charset=\"\(charset.rawValue)\""
            let defaultHeaders = [key: data]
            let lowerHeaders = [key: data.lowercased()]
            let upperHeaders = [key: data.uppercased()]
            let whiteSpacesHeaders = [key: data.split(separator: ";").joined(separator: "; ")]

            [defaultHeaders, lowerHeaders, upperHeaders, whiteSpacesHeaders].forEach { headers in
                let model = contentTypeDecoder.contentType(headers: headers)
                XCTAssertEqual(model?.charset, charset)
            }
        }
    }

    func testShouldDecodeBoundary() {
        let boundary = Boundary(name: "isIsTesBoundary")!
        let contentTypeDecoder = ContentTypeDecoder()
        let charset = Charset.iso88591

        func test(data: String) {
            let key = "Content-Type"
            let headers = [key: data]
            let model = contentTypeDecoder.contentType(headers: headers)
            XCTAssertEqual(boundary.name, model?.boundary?.name)
            XCTAssertEqual(charset, model?.charset)
        }

        test(data: "text/other;charset=\(charset.rawValue);boundary=\(boundary.name)")
        test(data: "text/other;boundary=\(boundary.name);charset=\(Charset.iso88591.rawValue)")
    }
}
