//
//  Recipient.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 11.05.2022.
//

import Foundation

public enum RecipientType: String, CaseIterable {
    case from = "From"
    case to = "To"
    case cc = "Cc"
    case bcc = "Bcc"
}

public struct Recipient {
    public let mail: String
    public let name: String?
    public let type: RecipientType
}
