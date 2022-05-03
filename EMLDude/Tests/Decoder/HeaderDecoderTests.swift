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

        lineDecoder.lines = keysValue.map { LineModel.key(key: $0.0, data: $0.1, originalLine: "Nothing") }
        let components = Array(repeating: "component", count: keysValue.count)

        let model = headerDecoder.header(components: components)

        keysValue.forEach { key, value in
            XCTAssertEqual(model?.headers[key], value)
        }
        XCTAssertEqual(keysValue.count, keysValue.count)
        XCTAssertTrue(model?.components.isEmpty == true)
    }

    func testShouldNotDecodeKeysAfterCarriage() {
        let lineDecoder = MockLineDecoder()
        let headerDecoder = HeaderDecoder(line: lineDecoder)

        let lines: [LineModel] = [
            .carriage("\r"),
            .key(key: "key", data: "value", originalLine: ""),
            .key(key: "otherKey", data: "otherValue", originalLine: "")
        ]
        lineDecoder.lines = lines

        let model = headerDecoder.header(components: Array(repeating: "component", count: lines.count))
        XCTAssertTrue(model?.headers.isEmpty == true)
        XCTAssertEqual(lines.count - 1, model?.components.count)
    }

    func testShouldNotDecodeKeysAfterBoundary() {
        let lineDecoder = MockLineDecoder()
        let headerDecoder = HeaderDecoder(line: lineDecoder)
        let boundary = Boundary(name: "boundary")!

        let lines: [LineModel] = [
            .boundary(boundary: boundary, position: .start),
            .key(key: "key", data: "value", originalLine: ""),
            .key(key: "otherKey", data: "otherValue", originalLine: "")
        ]
        lineDecoder.lines = lines

        let model = headerDecoder.header(components: Array(repeating: "component", count: lines.count))
        XCTAssertTrue(model?.headers.isEmpty == true)
        XCTAssertEqual(lines.count, model?.components.count, "Need leave boundary line in components")
    }

    func testShouldTestDefaultBehaviorWithCarriage() {
        let lineDecoder = MockLineDecoder()
        let headerDecoder = HeaderDecoder(line: lineDecoder)

        let keysValue = [
            ("Check", "Key"),
            ("Second", "SecondKey"),
            ("Third", "ThirdKey")
        ]

        lineDecoder.lines = keysValue.map { LineModel.key(key: $0.0, data: $0.1, originalLine: "Nothing") }
        lineDecoder.lines.append(.carriage(""))
        lineDecoder.lines.append(contentsOf: Array(repeating: LineModel.data("data"), count: 10))

        let lines = lineDecoder.lines
        let model = headerDecoder.header(components: Array(repeating: "component", count: lines.count))

        keysValue.forEach { key, value in
            XCTAssertEqual(model?.headers[key], value)
        }
        XCTAssertEqual(lines.count - keysValue.count - 1, model?.components.count, "Should not contains carriage")
    }

    func testShouldTestDefaultBehaviorWithBoundary() {
        let lineDecoder = MockLineDecoder()
        let headerDecoder = HeaderDecoder(line: lineDecoder)
        let boundary = Boundary(name: "boundary")!

        let keysValue = [
            ("Check", "Key"),
            ("Second", "SecondKey"),
            ("Third", "ThirdKey")
        ]

        lineDecoder.lines = keysValue.map { LineModel.key(key: $0.0, data: $0.1, originalLine: "Nothing") }
        lineDecoder.lines.append(.boundary(boundary: boundary, position: .start))
        lineDecoder.lines.append(contentsOf: Array(repeating: LineModel.data("data"), count: 10))

        let lines = lineDecoder.lines
        let model = headerDecoder.header(components: Array(repeating: "component", count: lines.count))

        keysValue.forEach { key, value in
            XCTAssertEqual(model?.headers[key], value)
        }
        XCTAssertEqual(lines.count - keysValue.count, model?.components.count, "Should leave boundary line in components")
    }
}
