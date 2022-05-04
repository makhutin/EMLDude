//
//  BoundaryPartsDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 02.05.2022.
//

import Foundation

internal protocol BoundaryPartsDecoding {
    typealias Part = [String]
    typealias Parts = [Part]
    
    func parts(from components: [String], boundary: Boundary) -> Parts?
}

internal final class BoundaryPartsDecoder {
    typealias Part = [String]
    typealias Parts = [Part]

    private let lineDecoder: LineDecoding

    init(line: LineDecoding) {
        self.lineDecoder = line
    }

    func parts(from components: [String], boundary: Boundary) -> Parts? {
        var parts = [[String]]()
        var currentPart = [String]()
        var isPreamble = true

        decoding: for component in components {
            let line = self.lineDecoder.line(line: component, mode: .boundary(boundary: boundary))
            switch line {
            case .boundary(let position):
                switch position {
                case .middle:
                    isPreamble = false
                    guard !currentPart.isEmpty else { continue }
                    parts.append(currentPart)
                    currentPart = []
                case .end:
                    parts.append(currentPart)
                    return parts
                }
            case .data(let line), .carriage(let line), .key(_, _, let line):
                guard !isPreamble else { continue }
                currentPart.append(line)
            }
        }
        return nil
    }
}
