//
//  MessageContent.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

public struct MessageContent {
    public enum SubTypes {
        case rfc822 // main
        case partial
        case externalBody // External-body
    }

    public let subType: SubTypes
    public let id: String?
    public let charset: Charset?
    public let transferEncoding: ContentTransferEncoding?
    public let description: String?

    public var type: ContentType {
        return .message
    }
}
