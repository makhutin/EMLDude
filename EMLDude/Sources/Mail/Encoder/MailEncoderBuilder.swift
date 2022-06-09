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
        let base64body = Base64BodyDecoder()
        let text = TextBodyEncoder(quotedPrintable: quotedPrintable, base64: base64body)
        let related = MultipartRelatedBodyEncoder(text: text)
        let multipart = MultipartBodyEncoder(related: related)
        let body = BodyEncoder(text: text, multipart: multipart)
        multipart.bodyEncoder = body
        return MailEncoder(recipients: recipients, subject: subject, date: date, body: body)
    }
}
