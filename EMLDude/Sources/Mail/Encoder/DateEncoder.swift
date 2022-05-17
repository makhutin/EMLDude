//
//  DateEncoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 17.05.2022.
//

import Foundation

internal final class DateEncoder {
    private enum Constants {
        static let dateKey = "Date"
        static let weekdDaySeporator = ", "
    }

    private let dateFormatter: DateFormatting

    init(dateFormatter: DateFormatting = DateFormatter.mailDateEncoderFormatter) {
        self.dateFormatter = dateFormatter
    }

    func date(from content: Content) -> Date? {
        guard let parameter = content.headears[Constants.dateKey] else { return nil }

        if let withoutWeekDay = parameter.components(separatedBy: Constants.weekdDaySeporator).last {
            return self.dateFormatter.date(from: withoutWeekDay)
        }
        return self.dateFormatter.date(from: parameter)
    }
}
