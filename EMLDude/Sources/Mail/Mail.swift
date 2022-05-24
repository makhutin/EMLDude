//
//  Mail.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

public struct Mail {
    public var recipients: Recipients
    public var subject: String?
    public var date: Date?
    public var body: String?
}

public extension Content {
    func mail() -> Mail {
        let encoder = MailEncoderBuilder.build()
        return encoder.encode(from: self)
    }
}
