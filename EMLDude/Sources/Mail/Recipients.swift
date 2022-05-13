//
//  Recipients.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

public struct Recipients {
    public let from: [Recipient]
    public let to: [Recipient]
    public let cc: [Recipient]
    public let bcc: [Recipient]
}

public struct Recipient {
    public let email: String
    public let name: String?
}

internal enum RecipientType: String, CaseIterable {
    case from = "From"
    case to = "To"
    case cc = "Cc"
    case bcc = "Bcc"
}
