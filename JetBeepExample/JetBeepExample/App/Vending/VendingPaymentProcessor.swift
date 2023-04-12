//
//  VendingPaymentProcessor.swift
//  ios_jetbeep
//
//  Created by Max Tymchii on 18.08.2021.
//  Copyright © 2021 Oleg Gordiychuck. All rights reserved.
//

import Foundation
import JetBeepFramework
import Promises

final class VendingPaymentProcessor {
    let paymentRequest: PaymentRequest
    let apiService: PaymentAPI

    init(paymentRequest: PaymentRequest) throws {
        self.paymentRequest = paymentRequest
        self.apiService = try PaymentAPI()
    }
}

extension VendingPaymentProcessor {
    func pay() async throws -> PaymentSignature {
        return try await apiService.paymentCreation(paymentRequest: paymentRequest)
    }

    func confirm(signature: ConfirmationSignature) async throws {
        return try await apiService.paymentConfirmation(paymentRequest: paymentRequest, signature: signature)
    }

}
