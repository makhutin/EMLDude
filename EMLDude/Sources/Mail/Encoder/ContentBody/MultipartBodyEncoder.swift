//
//  MultipartBodyEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 02.06.2022.
//

import Foundation

internal final class MultipartBodyEncoder: BodyContentEncoding {
    weak var bodyEncoder: BodyEncoder?

    func body(content: Content) -> String? {
        guard let content = content as? MultipartContent else { return nil }

        assert(self.bodyEncoder != nil, "Body encoder should be exist")

        switch content.subType {
        case .alternative:
            return self.alternativeBody(content: content)
        default:
            return nil
        }
    }

    private func alternativeBody(content: MultipartContent) -> String? {
        for content in self.sortedAlternativeContent(content: content) {
            if let body = self.bodyEncoder?.body(content: content) {
                return body
            }
        }
        return nil
    }

    private func sortedAlternativeContent(content: MultipartContent) -> [Content] {
        return content.contents.sorted { first, second -> Bool in
            switch (first.type, second.type) {
            case (.multipart, _):
                return true
            default:
                return false
            }
        }
    }
}
