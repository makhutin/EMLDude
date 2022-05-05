//
//  BoundaryPartsDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 02.05.2022.
//

import Foundation

internal protocol BoundaryPartsDecoding {
    func parts(from rawData: String, boundary: Boundary) -> ArraySlice<String>?
}

internal final class BoundaryPartsDecoder {
    func parts(from rawData: String, boundary: Boundary) -> ArraySlice<String>? {
        let parts = rawData.components(separatedBy: boundary.middle)
        let partsWithoutPreambula = parts.dropFirst()
        let partsWithoutBoundaryTail = partsWithoutPreambula.dropLast()
        return partsWithoutBoundaryTail
    }
}
