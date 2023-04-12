//
//  PaymentRequest+extension.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 10.04.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import Foundation
import JetBeepFramework

extension PaymentRequest {

    var body: JSONDictionary {
        ["vendor_transaction_id": transactionId,
         "vendor_amount": amount,
         "vendor_cashier_id": cashierId ?? "0",
         "shop_id": shop.id,
         "device_id": deviceId,
         "signature": signature ?? ""]
    }
}
