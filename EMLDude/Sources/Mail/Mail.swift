//
//  Mail.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

public struct Mail {
    public var recipients: Recipients
}

public extension Content {
    func mail() -> Mail {
        let encoder = MailEncoderBuilder.build()
        return encoder.encode(from: self)
    }
}
