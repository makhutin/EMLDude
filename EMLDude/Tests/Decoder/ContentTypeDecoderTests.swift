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
        let parametersDecoder = MockParametersDecoder()
        let contentTypeDecoder = ContentTypeDecoder(parameter: parametersDecoder)
        let key = ContentKeys.type.rawValue
        let checkData = "checkThisData"
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
            parametersDecoder.models = [.single(some: "\(type.rawValue)/\(subType)")]

            let model = contentTypeDecoder.contentType(headers: [key: checkData])
            XCTAssertEqual(parametersDecoder.data, checkData)

            XCTAssertEqual(type, model?.type)
            XCTAssertEqual(model?.subType, subType)
        }
    }

    func testShouldNotDecodeLine() {
        let parametersDecoder = MockParametersDecoder()
        let contentTypeDecoder = ContentTypeDecoder(parameter: parametersDecoder)
        let headers = ["Other-key": "no need decode"]
        let model = contentTypeDecoder.contentType(headers: headers)
        XCTAssertNil(model)
        XCTAssertNil(parametersDecoder.data)

        let typeData = "wrongType/mp4"
        parametersDecoder.models = [.single(some: typeData)]
        let wrongHeaders = [ContentKeys.type.rawValue: typeData]
        let modelSecond = contentTypeDecoder.contentType(headers: wrongHeaders)
        XCTAssertNil(modelSecond)
        XCTAssertEqual(parametersDecoder.data, typeData)
    }

    func testShouldDecodeCharset() {
        let parametersDecoder = MockParametersDecoder()
        let contentTypeDecoder = ContentTypeDecoder(parameter: parametersDecoder)
        let charsets: [Charset] = [
            .iso88591,
            .usAscii,
            .utf8
        ]

        charsets.forEach { charset in
            let key = ContentKeys.type.rawValue
            parametersDecoder.models = [
                .single(some: "\(ContentType.image.rawValue)/Subtype"),
                .keyValue(key: "charset", value: "\(charset.rawValue)")
            ]
            let checkData = "checkData"
            let model = contentTypeDecoder.contentType(headers: [key: checkData])
            XCTAssertEqual(model?.charset, charset)
            XCTAssertEqual(parametersDecoder.data, checkData)
        }
    }

    func testShouldDecodeBoundary() {
        let boundary = Boundary(name: "isIsTesBoundary")!
        let parametersDecoder = MockParametersDecoder()
        let contentTypeDecoder = ContentTypeDecoder(parameter: parametersDecoder)

        let key = ContentKeys.type.rawValue
        let checkData = "checkData"
        parametersDecoder.models = [
            .single(some: "\(ContentType.image.rawValue)/Subtype"),
            .keyValue(key: "boundary", value: boundary.name)
        ]
        let model = contentTypeDecoder.contentType(headers: [key: checkData])
        XCTAssertEqual(boundary.name, model?.boundary?.name)
        XCTAssertEqual(parametersDecoder.data, checkData)
    }
}

private extension ContentTypeDecoderTests {
    final class MockParametersDecoder: ParameterDecoding {
        var data: String?
        var models: [ParameterModel] = []
        func parameters(data: String) -> [ParameterModel] {
            self.data = data
            return self.models
        }
    }
}
