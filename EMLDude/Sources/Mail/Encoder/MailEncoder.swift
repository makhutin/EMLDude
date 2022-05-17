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
    private let date: DateEncoder

    init(recipients: RecipientsEncoder,
         subject: SubjectEncoder,
         date: DateEncoder) {
        self.recipients = recipients
        self.subject = subject
        self.date = date
    }

    func encode(from content: Content) -> Mail {
        let recipients = self.recipients.recipients(from: content)
        let subject = self.subject.subject(from: content)
        let date = self.date.date(from: content)
        return Mail(recipients: recipients, subject: subject, date: date)
    }
}
