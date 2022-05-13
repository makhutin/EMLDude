//
//  RecipientsEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

internal final class RecipientsEncoder {
    private let recipientParameterDecoder: RecipientParameterDecoding

    init(recipientParameterDecoder: RecipientParameterDecoding) {
        self.recipientParameterDecoder = recipientParameterDecoder
    }

    internal func recipients(from content: Content) -> Recipients {
        var recipientsByType: [RecipientType: [Recipient]] = [:]
        RecipientType.allCases.forEach { type in
            guard let data = content.headears[type.rawValue] else { return }

            let recipients = self.recipientParameterDecoder.recipients(from: data)
                .map { model -> Recipient in
                    switch model {
                    case .email(let email):
                        return Recipient(email: email, name: nil)
                    case .full(let name, let email):
                        return Recipient(email: email, name: name)
                    }
                }
            recipientsByType[type] = recipients
        }
        return Recipients(from: recipientsByType[.from] ?? [],
                          to: recipientsByType[.to] ?? [],
                          cc: recipientsByType[.cc] ?? [],
                          bcc: recipientsByType[.bcc] ?? [])
    }
}
