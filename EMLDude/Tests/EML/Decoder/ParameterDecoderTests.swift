//
//  ParameterDecoderTests.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 08.05.2022.
//

import XCTest
@testable import EMLDude

internal final class ParameterDecoderTests: XCTestCase {
    func testShouldCorrectParse() {
        let data = "inline; \r\nfilename=\"IMG_7119.PNG\"; boundary=\"boundary\";      type/subtype"
        let parameterDecoder = ParameterDecoder()
        let parameters = parameterDecoder.parameters(data: data)
        XCTAssertEqual(parameters, [
            .single(some: "inline"),
            .keyValue(key: "filename", value: "IMG_7119.PNG"),
            .keyValue(key: "boundary", value: "boundary"),
            .single(some: "type/subtype")
        ])
    }
}

extension ParameterModel: Equatable {
    public static func == (lhs: ParameterModel, rhs: ParameterModel) -> Bool {
        switch (lhs, rhs) {
        case (.single(let lSome), .single(let rSome)):
            return lSome == rSome
        case (.keyValue(let rKey, let rValue), .keyValue(let lKey, let lValue)):
            return lKey == rKey && lValue == rValue
        default:
            return false
        }
    }
}
