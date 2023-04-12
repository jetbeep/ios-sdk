//
//  PaymentAPI.swift
//  ios_jetbeep
//
//  Created by Max Tymchii on 18.08.2021.
//  Copyright © 2021 Oleg Gordiychuck. All rights reserved.
//

import Foundation
import JetBeepFramework
import Promises

class PaymentAPI {
    private let api: API

    init() throws {
        api = try API()
    }

    func paymentCreation(paymentRequest: PaymentRequest) async throws -> PaymentSignature {

        let body = try paymentRequest.body.toJSONData()

        Log.i("Payment creation")
        let result = try await api.call(.post,
                                        at: "/psp-main/\(paymentRequest.transactionId)",
                                        headers: API.headers,
                                        body: body)

        guard let resultBody = result.0.json as? [String: String],
              let signature = resultBody["signature"] else {
            throw ApiError.parsingFailed
        }

        return try PaymentSignature(value: signature)
    }

    func paymentConfirmation(paymentRequest: PaymentRequest, signature: ConfirmationSignature) async throws {

        let body = try ["signature": signature.signature].toJSONData()

        Log.i("Payment confirmation")

        _ = try await api.call(.patch, at: "/psp-main/\(paymentRequest.transactionId)",
                                        headers: API.headers, body: body)

    }
}
