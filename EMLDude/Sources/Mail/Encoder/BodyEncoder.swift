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

    init(text: BodyContentEncoding) {
        self.text = text
    }

    func body(content: Content) -> String? {
        switch content.type {
        case .text:
            return self.text.body(content: content)
        default:
            return nil
        }
    }
}
