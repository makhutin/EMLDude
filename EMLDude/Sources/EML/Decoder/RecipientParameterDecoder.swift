//
//  RecipientParameterDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

internal enum RecipientParamterModel {
    case email(email: String)
    case full(name: String, email: String)
}


internal final class RecipientParameterDecoder {
    private enum Constants {
        static let recipientsSeparator = ","
        static let startEmailSymbol = "<"
        static let endEmailSymbol = ">"
    }

    private let base64Decoder: Base64ParameterDecoder

    init(base64Decoder: Base64ParameterDecoder) {
        self.base64Decoder = base64Decoder
    }

    internal func recipients(from data: String) -> [RecipientParamterModel] {
        let recipients = data.components(separatedBy: Constants.recipientsSeparator)
        return recipients.map { self.recipient(from: $0) }
    }

    private func recipient(from recipient: String) -> RecipientParamterModel {
        if recipient.contains(Constants.endEmailSymbol) {
            return self.email(from: recipient)
        } else {
            return .email(email: recipient)
        }
    }

    private func email(from recipient: String) -> RecipientParamterModel {
        guard let endEmailIndex = recipient.lastIndex(of: Constants.endEmailSymbol.first!),
              let startEmailIndex = recipient.lastIndex(of: Constants.startEmailSymbol.first!) else { return
                .email(email: recipient)
        }

        let email = String(recipient[startEmailIndex...endEmailIndex])
        let name = self.name(from: recipient, email: email)

        return .full(name: name.withoutQuotes, email: email.removeCharacters(characters: Constants.startEmailSymbol + Constants.endEmailSymbol))
    }

    private func name(from recipient: String, email: String) -> String {
        let rawName = recipient.replacingOccurrences(of: email, with: String.empty)
        let startIndex = rawName.firstIndex { !$0.isNewline && !$0.isWhitespace } ?? rawName.startIndex
        let endIndex = rawName.lastIndex { !$0.isNewline && !$0.isWhitespace } ?? rawName.endIndex
        let name = String(rawName[startIndex...endIndex])

        return self.base64Decoder.decodeIfNeeded(parameter: name)
    }
}
