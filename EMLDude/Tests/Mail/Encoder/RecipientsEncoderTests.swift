//
//  RecipientsEncoderTests.swift
//  EMLDude-Unit-Tests
//
//  Created by Aleksey Makhutin on 13.05.2022.
//

import XCTest
@testable import EMLDude

internal final class RecipientsEncoderTests: XCTestCase {
    func testShouldCorrectDecode() {
        let recipientParameterDecoder = MockRecipientParameterDecoder()
        let recipientsEncoder = RecipientsEncoder(recipientParameterDecoder: recipientParameterDecoder)

        let resultEncoder = [RecipientParamterModel.email(email: "check"), .full(name: "name", email: "email")]
        recipientParameterDecoder.result = resultEncoder

        let mockContent = MockContent(type: .message)
        let checkData = ["fromData", "toData", "ccData", "bccData"]
        let types = [RecipientType.from, .to, .cc, .bcc]
        zip(types, checkData).forEach { (type, check) in
            mockContent.headears[type.rawValue] = check
        }

        let result = recipientsEncoder.recipients(from: mockContent)
        let checkRecipients: ([Recipient]) -> Void = { recipients in
            zip(recipients, resultEncoder).forEach { recipient, result in
                switch result {
                case .email(let email):
                    XCTAssertEqual(email, recipient.email)
                case .full(let name, let email):
                    XCTAssertEqual(email, recipient.email)
                    XCTAssertEqual(name, recipient.name)
                }
            }
        }
        checkRecipients(result.from)
        checkRecipients(result.to)
        checkRecipients(result.cc)
        checkRecipients(result.bcc)
        XCTAssertEqual(result.from.count, 2)
        XCTAssertEqual(result.to.count, 2)
        XCTAssertEqual(result.cc.count, 2)
        XCTAssertEqual(result.bcc.count, 2)

        XCTAssertEqual(recipientParameterDecoder.data.count, 4)
        zip(recipientParameterDecoder.data, checkData).forEach { data, check in
            XCTAssertEqual(data, check)
        }
    }
}

extension RecipientsEncoderTests {
    final class MockRecipientParameterDecoder: RecipientParameterDecoding {
        var data = [String]()
        var result = [RecipientParamterModel]()

        func recipients(from data: String) -> [RecipientParamterModel] {
            self.data.append(data)
            return self.result
        }
    }
}
