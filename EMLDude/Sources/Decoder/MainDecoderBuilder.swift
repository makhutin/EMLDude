//
//  MainDecoderBuilder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal enum MainDecoderBuilder {
    static func build() -> MainDecoder {
        let line = LineDecoder()
        let parameter = ParameterDecoder()
        let boundary = BoundaryPartsDecoder()
        let multipart = MultipartContentDecoder(boundary: boundary)
        let image = ImageContentDecoder()
        let text = TextContentDecoder()
        let application = ApplicationContentDecoder()
        let contentType = ContentTypeDecoder(parameter: parameter)
        let mainContent = MainContentDecoder(multipart: multipart,
                                             image: image,
                                             text: text,
                                             application: application,
                                             contentType: contentType)
        let header = HeaderDecoder(line: line)
        let main = MainDecoder(mainContent: mainContent, header: header)

        multipart.mainDecoder = main
        return main
    }
}
