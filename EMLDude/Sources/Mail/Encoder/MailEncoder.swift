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
    private let body: BodyEncoder

    init(recipients: RecipientsEncoder,
         subject: SubjectEncoder,
         date: DateEncoder,
         body: BodyEncoder) {
        self.recipients = recipients
        self.subject = subject
        self.date = date
        self.body = body
    }

    func encode(from content: Content) -> Mail {
        let recipients = self.recipients.recipients(from: content)
        let subject = self.subject.subject(from: content)
        let date = self.date.date(from: content)
        let body = self.body.body(content: content)
        return Mail(recipients: recipients, subject: subject, date: date, body: body)
    }
}
