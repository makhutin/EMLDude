//
//  MockLineDecoder.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation
@testable import EMLDude

internal final class MockLineDecoder: LineDecoding {
    var lines: [LineModel] = []

    func line(line: String) -> LineModel {
        guard let lineModel = self.lines.popFirts() else {
            assertionFailure()
            return .data("")
        }
        return lineModel
    }
}
