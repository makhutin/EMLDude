//
//  RecipientEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

internal final class RecipientsEncoder {
    private let recipientParameterDecoder: RecipientParameterDecoder
    init(recipientParameterDecoder: RecipientParameterDecoder) {
        self.recipientParameterDecoder = recipientParameterDecoder
    }

    internal func recipients(from content: Content) -> [Recipient] {
        RecipientType.allCases.map { type -> [Recipient] in
            guard let data = content.headears[type.rawValue] else { return [] }

            let recipients = self.recipientParameterDecoder.recipients(from: data)
                .map { model -> Recipient in
                    switch model {
                    case .email(let email):
                        return Recipient(mail: email, name: nil, type: type)
                    case .full(let name, let email):
                        return Recipient(mail: email, name: name, type: type)
                    }
                }
            return recipients
        }.flatMap { $0 }
    }
}
