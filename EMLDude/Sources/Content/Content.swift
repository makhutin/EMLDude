//
//  Content.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

public protocol Content: CustomStringConvertible {
    var headears: [String: String] { get }
    var id: String? { get }
    var charset: Charset? { get }
    var transferEncoding: ContentTransferEncoding? { get }
    var type: ContentType { get }
    var contents: [Content] { get }
}

extension Content {
    public var contents: [Content] {
        return []
    }
}

public enum ContentTransferEncoding: String {
    case bit7 // 7bit maybe US-ASCII.
    case bit8 // 8bit maybe contains not ASCII (128-255)
    case quotedPrintable // quoted-printable
    case binary
    case base64

    public init?(rawValue: String) {
        switch rawValue {
        case "7bit":
            self = .bit7
        case "bit8":
            self = .bit8
        case "quoted-printable":
            self = .quotedPrintable
        case "base64":
            self = .base64
        case "binary":
            self = .binary
        default:
            return nil
        }
    }
}

public enum Charset: String {
    case usAscii = "us-ascii"
    case iso88591 = "iso-8859-1"
    case utf8 = "utf-8"

    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case Charset.usAscii.rawValue:
            self = .usAscii
        case Charset.iso88591.rawValue:
            self = .iso88591
        case Charset.utf8.rawValue:
            self = .utf8
        default:
            print("Charset has not type: \(rawValue)")
            return nil
        }
    }
}

public enum ContentType: String {
    case application
    case audio
    case image
    case message
    case multipart
    case text
    case video

    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case ContentType.application.rawValue:
            self = .application
        case ContentType.audio.rawValue:
            self = .audio
        case ContentType.image.rawValue:
            self = .image
        case ContentType.message.rawValue:
            self = .message
        case ContentType.multipart.rawValue:
            self = .multipart
        case ContentType.text.rawValue:
            self = .text
        case ContentType.video.rawValue:
            self = .video
        default:
            return nil
        }
    }
}

internal enum ContentKeys: String {
    case id = "Content-ID"
    case type = "Content-Type"
    case transferEncoding = "Content-Transfer-Encoding"
}
