//
//  MultipartRelatedBodyEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 09.06.2022.
//

import Foundation

internal final class MultipartRelatedBodyEncoder {
    private let text: BodyContentEncoding
    init(text: BodyContentEncoding) {
        self.text = text
    }

    func body(content: MultipartContent) -> String? {
        guard let textContext = content.contents.first(where: { $0.type == .text }) as? TextContent,
              let body = self.text.body(content: textContext) else { return nil }

        let images = content.contents.compactMap { $0 as? ImageContent }
        return self.replaceImage(images: images, body: body)
    }

    private func replaceImage(images: [ImageContent], body: String) -> String {
        var body = body
        images.forEach { image in
            guard let encoding = image.info.transferEncoding,
                  let imageName = image.info.id?
                    .removeCharacters(characters: "<>")
                    .components(separatedBy: "@")
                    .first else { return }

            body = body.replacingOccurrences(of: "src=\"cid:\(imageName)",
                                      with: "src=\"data:\(image.type)/\(image.subType);\(encoding),\(image.rawData.withoutCarriage)")
        }
        return body
    }
}
