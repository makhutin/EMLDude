//
//  String+Extensions.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 30.04.2022.
//

import Foundation

extension String {
    private enum Constants {
        static let carriage = "\r"
    }

    internal static var empty: String {
        return ""
    }

    var withoutCarriage: String {
        return self.removeCharacters(characters: Constants.carriage)
    }

    func removeCharacters(characters: String) -> String {
        var charactersSet = CharacterSet()
        charactersSet.insert(charactersIn: characters)
        return self.removeCharacters(charactersSet: charactersSet)
    }

    func removeCharacters(charactersSet: CharacterSet) -> String {
        return components(separatedBy: charactersSet).joined(separator: .empty)
    }

    func getPostfixIfPrefix(isEqual to: String) -> String? {
        guard self.hasPrefix(to) else { return nil }
        return self.replacingOccurrences(of: to, with: String.empty)
    }

    var withoutQuotes: String {
        return self.removeCharacters(characters: "\"\'")
    }
}
