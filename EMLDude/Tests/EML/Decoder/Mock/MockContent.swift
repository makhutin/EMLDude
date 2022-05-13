//
//  MockContent.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 02.05.2022.
//

import Foundation
@testable import EMLDude

internal final class MockContent: Content {
    var headears: [String : String] = [:]
    var type: ContentType
    var rawData: String = ""
    var contents: [Content] = []
    var info: ContentInfo = ContentInfo()
    var description: String = ""

    init(type: ContentType) {
        self.type = type
    }
}
