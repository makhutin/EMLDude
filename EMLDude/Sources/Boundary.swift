//
//  BoundaryFinder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 30.04.2022.
//

import Foundation

internal enum BoundaryPosition {
    case middle
    case end
}

internal final class Boundary {
    private enum Constants {
        static let boundary = "boundary="
        static let determinant = "--"
    }
    let name: String

    var end: String {
        return Constants.determinant + self.name + Constants.determinant
    }

    var middle: String {
        return Constants.determinant + self.name
    }

    convenience init?(rawLine: String) {
        guard let name = rawLine
            .removeCharacters(charactersSet: .whitespaces)
            .getPostfixIfPrefix(isEqual: Constants.boundary)?
            .prepareBoundaryName else { return nil }

        self.init(name: name)
    }

    init?(name: String) {
        guard let name = name.checkBoundaryNameCount else { return nil }
        self.name = name.prepareBoundaryName
    }
}

private extension String {
    var prepareBoundaryName: String {
        return self.removeCharacters(characters: " \'\"\r")
    }

    var checkBoundaryNameCount: String? {
        guard self.count <= 70 else { return nil }
        // The boundary label must not exceed 70 characters in length
        return self
    }
}
