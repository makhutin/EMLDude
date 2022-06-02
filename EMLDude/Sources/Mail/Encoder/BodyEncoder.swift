//
//  BodyEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 19.05.2022.
//

import Foundation

internal protocol BodyContentEncoding {
    func body(content: Content) -> String?
}

internal final class BodyEncoder {
    private let text: BodyContentEncoding
    private let multipart: BodyContentEncoding

    init(text: BodyContentEncoding, multipart: BodyContentEncoding) {
        self.text = text
        self.multipart = multipart
    }

    func body(content: Content) -> String? {
        switch content.type {
        case .text:
            return self.text.body(content: content)
        case .multipart:
            return self.multipart.body(content: content)
        default:
            return nil
        }
    }
}
