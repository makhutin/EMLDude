//
//  TextBodyEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 19.05.2022.
//

import Foundation

internal final class TextBodyEncoder: BodyContentEncoding {
    private let quotedPrintable: QuotedPrintableDecoder
    private let base64: Base64BodyDecoder

    init(quotedPrintable: QuotedPrintableDecoder, base64: Base64BodyDecoder) {
        self.quotedPrintable = quotedPrintable
        self.base64 = base64
    }

    func body(content: Content) -> String? {
        guard let content = content as? TextContent else { return nil }

        switch content.info.transferEncoding {
        case .base64:
            return self.base64.decode(data: content.rawData)
        case .bit7, .bit8, .binary:
            return nil
        case .quotedPrintable:
            return self.quotedPrintable.decode(data: content.rawData)
        default:
            return nil
        }
    }
}
