//
//  BoundaryPartsDecoderTests.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 02.05.2022.
//

import XCTest
@testable import EMLDude

internal final class BoundaryPartsDecoderTests: XCTestCase {
    func testShouldDecodeWithoutBoundaryOnlyIfFirstLineContainsBoundaryDeclaration() {
        let lineDecoder = MockLineDecoder()
        let boundary = Boundary(name: "test-boundary")!
        let boundaryDecoder = BoundaryPartsDecoder(line: lineDecoder)
        let dataShouldByNotMidfied = "123 data\r\n\"\'%-"

        let lines: [LineModel] = [
            .boundary(boundary: boundary, position: .start),
            .data(dataShouldByNotMidfied),
            .key(key: "shound not contains key", data: "should not use data", originalLine: dataShouldByNotMidfied),
            .carriage(dataShouldByNotMidfied),
            .boundary(boundary: boundary, position: .end)
        ]

        lineDecoder.lines = lines
        let parts = boundaryDecoder.parts(from: Array(repeating: "Should use data from lineDecoder", count: lines.count), boundary: nil)
        XCTAssertEqual(parts?.count, 1)
        parts?.first?.forEach({ data in
            XCTAssertEqual(data, dataShouldByNotMidfied)
        })
    }

    func testShouldDecodeWithBoundary() {
        let lineDecoder = MockLineDecoder()
        let boundary = Boundary(name: "test-boundary")!
        let boundaryDecoder = BoundaryPartsDecoder(line: lineDecoder)
        let dataShouldByNotMidfied = "123 data\r\n\"\'%-"

        let lines: [LineModel] = [
            .data(dataShouldByNotMidfied),
            .key(key: "shound not contains key", data: "should not use data", originalLine: dataShouldByNotMidfied),
            .carriage(dataShouldByNotMidfied),
            .boundary(boundary: boundary, position: .end)
        ]

        lineDecoder.lines = lines
        let parts = boundaryDecoder.parts(from: Array(repeating: "Should use data from lineDecoder", count: lines.count), boundary: boundary)
        XCTAssertEqual(parts?.count, 1)
        parts?.first?.forEach({ data in
            XCTAssertEqual(data, dataShouldByNotMidfied)
        })
    }

    func testShouldNotDecode() {
        let boundary = Boundary(name: "test-boundary")!
        func test(lines: [LineModel], withBoundary: Bool) {
            let lineDecoder = MockLineDecoder()
            let boundaryDecoder = BoundaryPartsDecoder(line: lineDecoder)

            lineDecoder.lines = lines
            let parts = boundaryDecoder.parts(from: Array(repeating: "check", count: lines.count), boundary: withBoundary ? boundary : nil)
            XCTAssertNil(parts)
        }

        test(lines: [
            .data("firstLineNotContainsBoundary"),
            .boundary(boundary: boundary, position: .start),
            .data("firstLineNotContainsBoundary"),
            .boundary(boundary: boundary, position: .end),
        ], withBoundary: false)

        [BoundaryPosition.middle, .end].forEach { position in
            test(lines: [
                .boundary(boundary: boundary, position: position),
                .data("startFromNotStartBoundary"),
                .boundary(boundary: boundary, position: .end),
            ], withBoundary: false)
        }

        [BoundaryPosition.start, .middle].forEach { position in
            test(lines: [
                .boundary(boundary: boundary, position: .start),
                .data("endWithNotCorrectBoundary"),
                .boundary(boundary: boundary, position: position)
            ], withBoundary: false)
        }

        test(lines: [
            .boundary(boundary: boundary, position: .start),
            .data("endWithoutBoundary")
        ], withBoundary: false)

        [BoundaryPosition.start, .middle].forEach { position in
            test(lines: [
                .data("endWithNotCorrectBoundary"),
                .boundary(boundary: boundary, position: position)
            ], withBoundary: true)
        }

        test(lines: [
            .boundary(boundary: boundary, position: .start),
            .data("endWithoutBoundary")
        ], withBoundary: true)
    }

    func testShouldCorrectDecoderAndSplitByMiddleBoundary() {
        let lineDecoder = MockLineDecoder()
        let boundary = Boundary(name: "test-boundary")!
        let boundaryDecoder = BoundaryPartsDecoder(line: lineDecoder)
        let firstDataLine = "1 data\r"
        let secondDataLine = "2 data\r"
        let thirdDataLine = "2 data\r"

        var lines: [LineModel] = [
            .boundary(boundary: boundary, position: .start)
        ]

        let data: (String) -> [LineModel] = { data in
            return [
                .data(data),
                .key(key: "should not contains key", data: "should not use data", originalLine: data),
                .carriage(data),
            ]
        }

        lines.append(contentsOf: data(firstDataLine) + [.boundary(boundary: boundary, position: .middle)])
        lines.append(contentsOf: data(secondDataLine) + [.boundary(boundary: boundary, position: .middle)])
        lines.append(contentsOf: data(thirdDataLine) + [.boundary(boundary: boundary, position: .end)])

        lineDecoder.lines = lines
        let parts = boundaryDecoder.parts(from: Array(repeating: "Should use data from lineDecoder", count: lines.count), boundary: nil)
        XCTAssertEqual(parts?.count, 3)

        parts?.enumerated().forEach({ index, part in
            part.forEach { data in
                switch index {
                case 0:
                    XCTAssertEqual(data, firstDataLine)
                case 1:
                    XCTAssertEqual(data, secondDataLine)
                case 2:
                    XCTAssertEqual(data, thirdDataLine)
                default:
                    XCTFail()
                }
            }
        })
    }

}
