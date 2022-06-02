//
//  Base64BodyDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 02.06.2022.
//

import Foundation

internal final class Base64BodyDecoder {
    func decode(data: String) -> String? {
        return data.withoutCarriage.base64decode
    }
}
