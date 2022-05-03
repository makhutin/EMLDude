//
//  MockContent.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 02.05.2022.
//

import Foundation
@testable import EMLDude

internal final class MockContent: Content {
    var id: String?
    var charset: Charset?
    var transferEncoding: ContentTransferEncoding?
    let type: ContentType
    let description: String = ""

    init(type: ContentType) {
        self.type = type
    }
}
