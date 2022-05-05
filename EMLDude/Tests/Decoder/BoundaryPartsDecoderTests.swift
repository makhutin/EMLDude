//
//  BoundaryPartsDecoderTests.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 02.05.2022.
//

import XCTest
@testable import EMLDude

internal final class BoundaryPartsDecoderTests: XCTestCase {
    func testShouldBoundaryPartingCorrectWork() {
        let boundary = Boundary(name: "check_boundary_parting")!
        let preamble = "it is preable,\r should not get into the parts"
        let firstPart = "helloIamFirstPart\r\n Should not be changed"
        let secondPart = "helloIamSecondPart\r\n Should not be changed"
        let thirdPart = "helloIamThirdPart\t\n Should not be changed"
        var rawData = preamble
        rawData += boundary.middle
        rawData += firstPart
        rawData += boundary.middle
        rawData += secondPart
        rawData += boundary.middle
        rawData += thirdPart
        rawData += boundary.end + "It is tail\r, should not get into the parts"

        let boundaryPartsDecoder = BoundaryPartsDecoder()
        let parts = boundaryPartsDecoder.parts(from: rawData, boundary: boundary)
        XCTAssertEqual(parts?.count, 3)
        for (newPart, originalPart) in zip(parts ?? [], [firstPart, secondPart, thirdPart]) {
            XCTAssertEqual(newPart, originalPart)
        }

    }
}
