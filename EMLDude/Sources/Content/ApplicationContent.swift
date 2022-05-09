//
//  ApplicationContent.swift
//  EMLDude
//
//  Created by Aleksey Makhutin on 01.05.2022.
//

import Foundation

public struct ApplicationContent: Content {
    public enum SubTypes: CustomStringConvertible {
        private enum Constants {
            static let octetStream = "octet-stream"
            static let postScript = "post-script"
        }
        case octetStream
        case postScript
        case other(name: String)


        public init?(rawValue: String) {
            switch rawValue.lowercased() {
            case Constants.octetStream:
                self = .octetStream
            case Constants.postScript:
                self = .postScript
            default:
                self = .other(name: rawValue)
            }
        }

        public var description: String {
            switch self {
            case .octetStream:
                return Constants.octetStream
            case .postScript:
                return Constants.postScript
            case .other(let name):
                return "other-\(name)"
            }
        }
    }

    public let headears: [String : String]
    public let subType: SubTypes
    public let rawData: String
    public let info: ContentInfo

    public var type: ContentType {
        return .application
    }

    public var description: String {
        return [
            "Content-Type: \(self.type.rawValue)/\(self.subType)",
            self.info.description
        ].joined(separator: "\n")
    }
}
