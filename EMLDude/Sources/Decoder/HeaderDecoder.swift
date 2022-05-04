//
//  HeaderDecoder.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

internal struct HeaderModel {
    let headers: [String: String]
    let components: [String]
}

internal protocol HeaderDecoding {
    func header(components: [String]) -> HeaderModel?
}

internal final class HeaderDecoder: HeaderDecoding {
    private let lineDecoder: LineDecoding

    init(line: LineDecoding) {
        self.lineDecoder = line
    }

    func header(components: [String]) -> HeaderModel? {
        var headers = [String: String]()

        var shouldDecodeLine = true
        var newComponents = [String]()
        var buffer: String?
        var key: String?

        for component in components {
            if shouldDecodeLine {
                let line = self.lineDecoder.line(line: component, mode: .easy)
                switch line {
                case .carriage:
                    key.map { headers[$0] = buffer?.withoutCarriage }
                    key = nil
                    buffer = nil
                    shouldDecodeLine = false
                case .data(let newData):
                    buffer = (buffer ?? "") + newData
                case .key(let newKey, let newData, _):
                    key.map { headers[$0] = buffer?.withoutCarriage }
                    key = newKey
                    buffer = newData
                default:
                    break
                }
            } else {
                newComponents.append(component.withoutCarriage.withCarriage)
            }
        }
        key.map { headers[$0] = buffer?.withoutCarriage }

        return HeaderModel(headers: headers, components: newComponents)
    }
}
