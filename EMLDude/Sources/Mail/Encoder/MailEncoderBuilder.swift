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
        return MailEncoder(recipients: recipients)
    }
}