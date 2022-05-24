//
//  QuotedPrintableDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 19.05.2022.
//

import Foundation

internal final class QuotedPrintableDecoder {
    private enum Constants {
        static let lineTransfer = "=\r"
        static let encodedCharEscaping = "=".first
    }

    func decode(data: String) -> String? {
        let dataWithoutExtraLines = self.removeAllLineTransfers(data: data)
        return self.convertHexCharacters(data: dataWithoutExtraLines)
    }

    private func removeAllLineTransfers(data: String) -> String {
        return data
            .replacingOccurrences(of: Constants.lineTransfer, with: "")
            .replacingOccurrences(of: "\r", with: "\n")

    }

    private func convertHexCharacters(data: String) -> String {
        var result = [String.Element]()
        var fistHexBuffer = [String.Element]()
        var secondHexBuffer = [String.Element]()

        var state: State = .findEscaping
        enum State {
            case findEscaping
            case readFirstSymbol(isFirstEscaping: Bool)
            case readLastSymbol(isFirstEscaping: Bool)
            case checkNextEscaping
        }

        func saveCharFromBufferAndClearBuffers() {
            self.hexToChar(firstHex: String(fistHexBuffer),
                           secondHex: String(secondHexBuffer))
                .map { result.append($0) }
            fistHexBuffer = []
            secondHexBuffer = []
        }

        data.forEach { char in
            switch state {
            case .findEscaping where char == Constants.encodedCharEscaping:
                state = .readFirstSymbol(isFirstEscaping: true)
            case .readFirstSymbol(let isFirstEscaping):
                isFirstEscaping ? fistHexBuffer.append(char) : secondHexBuffer.append(char)
                state = .readLastSymbol(isFirstEscaping: isFirstEscaping)
            case .readLastSymbol(let isFirstEscaping):
                if isFirstEscaping {
                    fistHexBuffer.append(char)
                    state = .checkNextEscaping
                } else {
                    secondHexBuffer.append(char)
                    saveCharFromBufferAndClearBuffers()
                    state = .findEscaping
                }
            case .checkNextEscaping:
                if char == Constants.encodedCharEscaping {
                    state = .readFirstSymbol(isFirstEscaping: false)
                } else {
                    saveCharFromBufferAndClearBuffers()
                    result.append(char)
                    state = .findEscaping
                }
            default:
                result.append(char)
            }
        }
        return String(result)
    }

    private func hexToChar(firstHex: String, secondHex: String) -> String.Element? {
        guard let firstByte = Int(firstHex, radix: 16) else { return nil }

        var bytes = [UInt8(firstByte)]
        if let secondByte = secondHex.isEmpty ? nil : Int(secondHex, radix: 16) {
            bytes.append(UInt8(secondByte))
        }
        return String(bytes: bytes, encoding: .utf8)?.first
    }
}
