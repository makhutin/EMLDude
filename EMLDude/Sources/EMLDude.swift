//
//  EMLDude.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 30.04.2022.
//

import Foundation

public enum EMLDudeError: Error {
    case cantDecodeData
}

public struct EMLDude {
    public var content: Content?

    public init(data: Data) throws {
        let decoder = MainDecoderBuilder.build()
        self.content = try decoder.content(from: data)
    }
}

extension EMLDude: CustomStringConvertible {
    public var description: String {
        return self.content?.description ?? "No content"
    }
}
