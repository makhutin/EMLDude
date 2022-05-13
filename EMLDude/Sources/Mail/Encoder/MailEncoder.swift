//
//  MailEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

internal final class MailEncoder {
    private let recipients: RecipientsEncoder
    private let subject: SubjectEncoder

    init(recipients: RecipientsEncoder,
         subject: SubjectEncoder) {
        self.recipients = recipients
        self.subject = subject
    }

    func encode(from content: Content) -> Mail {
        let recipients = self.recipients.recipients(from: content)
        let subject = self.subject.subject(from: content)
        return Mail(recipients: recipients, subject: subject)
    }
}
