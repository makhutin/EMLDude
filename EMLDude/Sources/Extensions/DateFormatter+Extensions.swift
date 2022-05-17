//
//  DateFormatter+Extensions.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 17.05.2022.
//

import Foundation

internal extension DateFormatter {
    static var mailDateEncoderFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss Z"
        return dateFormatter
    }
}

internal protocol DateFormatting {
    func date(from string: String) -> Date?
}

extension DateFormatter: DateFormatting {}
