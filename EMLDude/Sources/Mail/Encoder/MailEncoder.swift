//
//  MailEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

internal final class MailEncoder {
    private let recipients: RecipientsEncoder
    init(recipients: RecipientsEncoder) {
        self.recipients = recipients
    }

    func encode(from content: Content) -> Mail {
        let recipients = self.recipients.recipients(from: content)
        return Mail(recipients: recipients)
    }
}
