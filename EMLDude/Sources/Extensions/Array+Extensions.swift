//
//  Array+Extensions.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal extension Array {
    mutating func popFirts() -> Element? {
        let pop = self.first
        self = self.dropFirst().map { $0 }
        return pop
    }
}
