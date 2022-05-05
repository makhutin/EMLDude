//
//  HeaderDecoderTests.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import XCTest
@testable import EMLDude

internal final class HeaderDecoderTests: XCTestCase {
    func testShouldCorrectDecodeHeaders() {
        let lineDecoder = MockLineDecoder()
        let headerDecoder = HeaderDecoder(line: lineDecoder)

        let keysValue = [
            ("Check", "Key"),
            ("Second", "SecondKey"),
            ("Third", "ThirdKey")
        ]

        lineDecoder.lines = keysValue.map { LineModel.key(key: $0.0, data: $0.1) }
        let rawData = "line\r line\r line\r\r"

        let model = headerDecoder.header(rawData: rawData)

        keysValue.forEach { key, value in
            XCTAssertEqual(model?.headers[key], value)
        }
        XCTAssertEqual(keysValue.count, keysValue.count)
        XCTAssertTrue(model?.rawData.isEmpty == true)
    }

    func testShouldNotDecodeKeysAfterDoubleCarriage() {
        let lineDecoder = MockLineDecoder()
        let headerDecoder = HeaderDecoder(line: lineDecoder)

        let lines: [LineModel] = [
            .key(key: "key", data: "value"),
            .key(key: "notDecodedKey", data: "notDecodedKey")
        ]
        lineDecoder.lines = lines
        let data = "some data"

        let model = headerDecoder.header(rawData: "onlyonekey\r\r\(data)")
        XCTAssertEqual(model?.headers.count, 1)
        XCTAssertEqual(data, model?.rawData)
    }

    func testShouldTestDefaultBehaviorWithCarriage() {
        let lineDecoder = MockLineDecoder()
        let headerDecoder = HeaderDecoder(line: lineDecoder)

        let keysValue = [
            ("Check", "Key"),
            ("Second", "SecondKey"),
            ("Third", "ThirdKey")
        ]

        lineDecoder.lines = keysValue.map { LineModel.key(key: $0.0, data: $0.1) }
        lineDecoder.lines.append(contentsOf: Array(repeating: LineModel.data("data"), count: 10))
        let data = String(repeating: "data\r\r\n", count: 10)
        let rawData = String(repeating: "component\r", count: keysValue.count) + "\r" + data

        let model = headerDecoder.header(rawData: rawData)

        keysValue.forEach { key, value in
            XCTAssertEqual(model?.headers[key], value)
        }
        XCTAssertEqual(data, model?.rawData, "Should not be changed")
    }
}
