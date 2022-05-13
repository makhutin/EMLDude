//
//  RecipientParameterDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

internal protocol RecipientParameterDecoding {
    func recipients(from data: String) -> [RecipientParamterModel]
}

internal enum RecipientParamterModel {
    case email(email: String)
    case full(name: String, email: String)
}

internal final class RecipientParameterDecoder: RecipientParameterDecoding {
    private enum Constants {
        static let recipientsSeparator = ","
        static let startEmailSymbol = "<"
        static let endEmailSymbol = ">"
    }

    private let base64Decoder: Base64ParameterDecoding

    init(base64Decoder: Base64ParameterDecoding) {
        self.base64Decoder = base64Decoder
    }

    internal func recipients(from data: String) -> [RecipientParamterModel] {
        let recipients = data.components(separatedBy: Constants.recipientsSeparator)
        return recipients
            .filter { !$0.isEmpty }
            .map { self.recipient(from: $0.clearExtraNewlinesAndSpaces) }
    }

    private func recipient(from recipient: String.SubSequence) -> RecipientParamterModel {
        if recipient.contains(Constants.endEmailSymbol) {
            return self.email(from: recipient)
        } else {
            return .email(email: String(recipient).clearExtraSymbols)
        }
    }

    private func email(from recipient: String.SubSequence) -> RecipientParamterModel {
        guard let endEmailIndex = recipient.lastIndex(of: Constants.endEmailSymbol.first!),
              let startEmailIndex = recipient.lastIndex(of: Constants.startEmailSymbol.first!) else { return
                .email(email: String(recipient).clearExtraSymbols)
        }

        let email = String(recipient[startEmailIndex...endEmailIndex])
        if let name = self.name(from: recipient, email: email) {
            return .full(name: name.withoutQuotes, email: email.clearExtraSymbols)
        }
        return .email(email: email.clearExtraSymbols)
    }

    private func name(from recipient: String.SubSequence, email: String) -> String? {
        guard recipient.count != email.count else { return nil }

        let rawName = recipient.replacingOccurrences(of: email, with: String.empty)
        let startIndex = rawName.firstIndex { !$0.isNewline && !$0.isWhitespace } ?? rawName.startIndex
        let endIndex = rawName.lastIndex { !$0.isNewline && !$0.isWhitespace } ?? rawName.endIndex
        let name = String(rawName[startIndex...endIndex])

        return self.base64Decoder.decodeIfNeeded(parameter: name)
    }
}

private extension String {
    var clearExtraSymbols: String {
        return self.removeCharacters(characters: "\"\'<>")
    }

    var clearExtraNewlinesAndSpaces: String.SubSequence {
        let startIndex = self.firstIndex { !$0.isNewline && !$0.isWhitespace } ?? self.startIndex
        let endIndex = self.lastIndex { !$0.isNewline && !$0.isWhitespace } ?? self.endIndex
        return self[startIndex...endIndex]
    }
}
