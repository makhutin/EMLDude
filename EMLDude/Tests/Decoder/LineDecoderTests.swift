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
            "should \"\'decode some data;"
        ]
        let lines = zip(keys, data).map { $0.0 + ": " + $0.1 }

        let lineDecoder = LineDecoder()

        let boundary = Boundary(name: "\"it is new boundary\"")
        [LineMode.easy, .boundary(boundary: nil), .boundary(boundary: boundary)].forEach { mode in
            lines.enumerated().forEach { index, line in
                let resutl = lineDecoder.line(line: line, mode: mode)
                switch resutl {
                case .key(let key, let lineData, let originalLine):
                    XCTAssertEqual(originalLine, line)
                    XCTAssertEqual(keys[index], key)
                    XCTAssertEqual(data[index], lineData)
                default:
                    XCTFail()
                }
            }
        }
    }

    func testEasyShouldDecodeCarrige() {
        let lines = [
            "\r",
            ""
        ]
        let lineDecoder = LineDecoder()

        let boundary = Boundary(name: "\"it is new boundary\"")
        [LineMode.easy, .boundary(boundary: nil), .boundary(boundary: boundary)].forEach { mode in
            lines.forEach { line in
                let resutl = lineDecoder.line(line: line, mode: mode)
                switch resutl {
                case .carriage(let originalLine):
                    XCTAssertEqual(originalLine, line)
                default:
                    XCTFail()
                }
            }
        }
    }

    func testShoudlNewBoundary() {
        let lines = [
            "boundary=\"it is new boundary\"",
            "boundary=it is new boundary",
            "boundary=\'it is new boundary\'"
        ]

        let lineDecoder = LineDecoder()
        lines.forEach { line in
            let result = lineDecoder.line(line: line, mode: .boundary(boundary: nil))
            switch result {
            case .boundary(let boundary, let pos):
                guard case BoundaryPosition.start = pos else {
                    XCTFail()
                    break
                }
                XCTAssertEqual(boundary.name, "itisnewboundary")
            default:
                XCTFail()
            }
        }
    }

    func testShoudlNotNewBoundary() {
        let lines = [
            "--itisnewboundary",
            "--itisnewboundary--",
        ]

        let position = [
            BoundaryPosition.middle,
            BoundaryPosition.end
        ]
        let boundary = Boundary(name: "\"it is new boundary\"")

        let lineDecoder = LineDecoder()
        lines.enumerated().forEach { index, line in
            let resutl = lineDecoder.line(line: line, mode: .boundary(boundary: boundary))
            switch resutl {
            case .boundary(let newBoundary, let pos):
                XCTAssertEqual(pos, position[index])
                XCTAssertEqual(newBoundary.name, boundary?.name)
            default:
                XCTFail()
            }
        }
    }

    func testShoudReturnData() {
        let moreThan72SymbolsString = String(repeating: "s", count: 73)
        let boundary = Boundary(name: "\"it is new boundary\"")!

        let lines = [
            "foo bar baz",
            "itisnotnewboundary",
            "some:string",
            "boundary=\(moreThan72SymbolsString)",
            "---\(boundary.name)",
            "---\(boundary.name)---",
            "-\(boundary.name)",
            "-\(boundary.name)-",
            "123:321:123",
            "whiteSpace : not need"
        ]

        let lineDecoder = LineDecoder()
        [LineMode.easy, .boundary(boundary: nil), .boundary(boundary: boundary)].forEach { mode in
            lines.forEach { line in
                let result = lineDecoder.line(line: line, mode: .boundary(boundary: nil))
                switch result {
                case .data(let newLine):
                    XCTAssertEqual(line, newLine)
                default:
                    XCTFail()
                }
            }
        }
    }
}
