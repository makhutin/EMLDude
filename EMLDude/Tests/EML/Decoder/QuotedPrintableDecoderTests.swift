//
//  QuotedPrintableDecoderTests.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 27.05.2022.
//

import Foundation

import XCTest
@testable import EMLDude

internal final class QuotedPrintableDecoderTests: XCTestCase {
    func testShouldDecode() {
        let transfer = "=\r"
        let testParameters = [
            "=D0=9F=D1=80=D0=BE=D0=B2=D0=B5=D1=80=D0=BA=D0=B0 =D0=BA=D0=B8=D1=80=D0=B8=D0\(transfer)=BB=D0=BB=D0=B8=D1=86=D1=8B",
            "check tran\(transfer)sfers",
            "=09, =20, =0D, =0A, =3D",
            "Should\rReplace\rWith\rNewlines\r"

        ]
        let checkParameters = [
            "Проверка кириллицы",
            "check transfers",
            "\t,  , \r, \n, =",
            "Should\nReplace\nWith\nNewlines\n"
        ]
        let decoder = QuotedPrintableDecoder()
        zip(testParameters, checkParameters).forEach { (test, check) in
            let result = decoder.decode(data: test)
            XCTAssertEqual(result, check)
        }
    }
}
