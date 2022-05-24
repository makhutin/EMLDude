//
//  TextBodyEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 19.05.2022.
//

import Foundation

internal final class TextBodyEncoder: BodyContentEncoding {
    private let quotedPrintable: QuotedPrintableDecoder

    init(quotedPrintable: QuotedPrintableDecoder) {
        self.quotedPrintable = quotedPrintable
    }

    func body(content: Content) -> String? {
        guard let content = content as? TextContent else { return nil }

        switch content.info.transferEncoding {
        case .base64:
            return nil
        case .bit7, .bit8, .binary:
            return nil
        case .quotedPrintable:
            return self.quotedPrintable.decode(data: content.rawData)
        default:
            return nil
        }
    }
}
