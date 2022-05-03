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
    
    func parts(from components: [String], boundary: Boundary?) -> Parts?
}

internal final class BoundaryPartsDecoder {
    typealias Part = [String]
    typealias Parts = [Part]

    private let lineDecoder: LineDecoding

    init(line: LineDecoding) {
        self.lineDecoder = line
    }

    func parts(from components: [String], boundary: Boundary?) -> Parts? {
        if let boundary = boundary {
            return self.findParts(from: components[...], boundary: boundary)
        } else if let boundary = self.boundary(components: components) {
            return self.findParts(from: components.dropFirst(), boundary: boundary)
        }
        return nil
    }

    private func findParts(from components: ArraySlice<String>, boundary: Boundary) -> Parts? {
        var parts = [[String]]()
        var currentPart = [String]()

        decoding: for component in components {
            let line = self.lineDecoder.line(line: component, mode: .boundary(boundary: boundary))
            switch line {
            case .boundary(_, let position):
                switch position {
                case .middle:
                    parts.append(currentPart)
                    currentPart = []
                case .end:
                    parts.append(currentPart)
                    return parts
                case .start:
                    break
                }
            case .data(let line), .carriage(let line), .key(_, _, let line):
                currentPart.append(line)
            }
        }
        return nil
    }

    private func boundary(components: [String]) -> Boundary? {
        let line = self.lineDecoder.line(line: components.first ?? "", mode: .boundary(boundary: nil))
        if case let LineModel.boundary(boundary, position) = line,
           position == .start {
            return boundary
        }
        return nil
    }
}
