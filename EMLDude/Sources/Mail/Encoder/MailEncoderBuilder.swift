//
//  MailEncoderBuilder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

internal enum MailEncoderBuilder {
    static func build() -> MailEncoder {
        let base64Decoder = Base64ParameterDecoder()
        let recipientParameter = RecipientParameterDecoder(base64Decoder: base64Decoder)
        let recipients = RecipientsEncoder(recipientParameterDecoder: recipientParameter)
        let subject = SubjectEncoder(base64ParameterDecoder: base64Decoder)
        let date = DateEncoder()
        return MailEncoder(recipients: recipients, subject: subject, date: date)
    }
}
