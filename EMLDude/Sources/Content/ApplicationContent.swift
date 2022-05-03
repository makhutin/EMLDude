//
//  ApplicationContent.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

public struct ApplicationContent {
    public enum SubTypes {
        case octetStream // octet-stream
        case postScript // PostScript
    }

    public let subType: SubTypes
    public let id: String?
    public let charset: Charset?
    public let transferEncoding: ContentTransferEncoding?
    public let description: String?

    public var type: ContentType {
        return .application
    }
}
