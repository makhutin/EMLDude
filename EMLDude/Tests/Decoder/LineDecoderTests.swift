//
//  LineDecoderTests.swift
//  
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import XCTest
@testable import EMLDude

internal final class LineDecoderTests: XCTestCase {
    func testEasyShoudlDecodeKeysCorrect() {
        let keys = [
            "some-test",
            "test",
            "t"
        ]
        let data = [
            "should: decode",
            "should-decode",
            "should \"\'\rdecode\n\rsome\rdata;"
        ]
        let lines = zip(keys, data).map { $0.0 + ": " + $0.1 }

        let lineDecoder = LineDecoder()

        lines.enumerated().forEach { index, line in
            let resutl = lineDecoder.line(line: line)
            switch resutl {
            case .key(let key, let lineData):
                XCTAssertEqual(keys[index], key)
                XCTAssertEqual(data[index], lineData, "Should not change line")
            default:
                XCTFail()
            }
        }

    }

    func testShoudReturnData() {
        let boundary = Boundary(name: "\"it is boundary\"")!
        let lines = [
            "foo bar baz",
            "itisnotnewboundary",
            "some:string",
            "---\(boundary.name)",
            "---\(boundary.name)---",
            "-\(boundary.name)",
            "-\(boundary.name)-",
            "123:321:123",
            "whiteSpace : not need"
        ]

        let lineDecoder = LineDecoder()
        lines.forEach { line in
            let result = lineDecoder.line(line: line)
            switch result {
            case .data(let newLine):
                XCTAssertEqual(line, newLine)
            default:
                XCTFail()
            }
        }
    }
}
