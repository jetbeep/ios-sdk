//
//  JetBeepBarcodeHandler.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 2/27/19.
//  Copyright © 2019 Max Tymchii. All rights reserved.
//

import Foundation
import JetBeepFramework

final class JetBeepBarcodeHandler: JBBarcodeRequestProtocol {
    var delegate: JBBarcodeTransferProtocol?

    func barcodeRequest(merchant: Merchant, shop: Shop) -> [Barcode] {
        //Put your barcodes based on merchant and shop
        return [Barcode(withValue: "123456789"), Barcode(withValue: "789102335"), Barcode(withValue: "111111111111")]
    }

}
