//
//  MailEncoderBuilder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

internal enum MailEncoderBuilder {
    static func build() -> MailEncoder {
        let base64ParameterDecoder = Base64ParameterDecoder()
        let recipientParameter = RecipientParameterDecoder(base64Decoder: base64ParameterDecoder)
        let recipients = RecipientsEncoder(recipientParameterDecoder: recipientParameter)
        let subject = SubjectEncoder(base64ParameterDecoder: base64ParameterDecoder)
        let date = DateEncoder()
        let quotedPrintable = QuotedPrintableDecoder()
        let text = TextBodyEncoder(quotedPrintable: quotedPrintable)
        let body = BodyEncoder(text: text)
        return MailEncoder(recipients: recipients, subject: subject, date: date, body: body)
    }
}
