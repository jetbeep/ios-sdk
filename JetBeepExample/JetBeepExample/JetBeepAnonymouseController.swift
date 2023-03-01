//
//  JetBeepAnonymouseController
//  JetBeepExample
//
//  Created by Max Tymchii on 2/26/19.
//  Copyright © 2019 Max Tymchii. All rights reserved.
//

import Foundation
import JetBeepFramework
import Combine

final class JetBeepAnonymouseController: NSObject {

    static let shared = JetBeepAnonymouseController()
    var subscriptions: Set<AnyCancellable> = []
    
    lazy var locationsManager: LocationsManager = {
        return LocationsManager()
    }()

    private override init() {}
    
    let barcodeHandler = JetBeepBarcodeHandler()

//    func setup() {
//        JetBeep.shared.serverType = .pro
//        JetBeep.shared.registrationType = .anonymous
//        JetBeep.shared.setup(appName: "jetbeep-test-2", appTokenKey: "6538c072-bf9e-41f6-96fc-d6de16f46fa0")
//        JetBeep.shared.serviceUUID = "0179e"
//        JetBeep.shared.barcodeRequestHandler = barcodeHandler
//        barcodeHandler.delegate = self
//        AnalyticsManager.shared.start()
//
//        Log.isLoggingEnabled = true
//    }

    func setup() {
       

        JetBeep.shared.serverType = .production
        JetBeep.shared.registrationType = .anonymous
        JetBeep.shared.setup(appName: appNameKey, appTokenKey: appToken)
        JetBeep.shared.serviceUUID = serviceUUID

           JetBeep.shared.barcodeRequestHandler = barcodeHandler
           barcodeHandler.delegate = self
           AnalyticsManager.shared.start()

           Log.isLoggingEnabled = true
       }



    func cacheData() {
        JetBeep.shared.sync()
            .then { _ in
                Log.d("cached successfully")
            }.catch { e in
                Log.w("unable to cache: \(e)")
        }
    }

    func startMonitoring() {

        locationsManager.start()
        Log.d("monitoring started")

        
        do {
            try JBBeeper.shared.start()
        } catch {
            print(error)
        }
    }

    func subscribeOnLocationEvents() {

        locationsManager
            .devicesCallback.sink { signal in
                switch signal.event {
                case .found:
                    Log.i("Device found \(signal.device)")
                case .lost:
                    Log.i("Device lost \(signal.device)")
                @unknown default:
                    fatalError("This API was changed, please review this code")
                }
            }.store(in: &subscriptions)

        locationsManager
            .merchantsCallback
            .sink { signal in
                switch signal.event {
                case .entered:
                    Log.i("Entered at merchant: \(signal.merchant.name)")
                case .exited:
                    Log.i("Exited from merchant: \(signal.merchant.name)")
                @unknown default:
                    fatalError("This API was changed, please review this code")
                }
            }.store(in: &subscriptions)

        locationsManager
            .shopsCallback
            .sink { signal in
                switch signal.event {
                case .entered:
                    Log.i("Entered at shop: \(signal.shop.name)")
                case .exited:
                    Log.i("Exited form shop: \(signal.shop.name)")
                @unknown default:
                    fatalError("This API was changed, please review this code")
                }
            }.store(in: &subscriptions)

    }
    
    deinit {
        locationsManager.stop()
    }
    
}

extension JetBeepAnonymouseController: JBBarcodeTransferProtocol {
    public func succeedBarcodeTransfer(merchant: Merchant, shop: Shop) {
        Log.i("Succeed barcode Transfer")
    }

    public func failureBarcodeTransfer(merchant: Merchant, shop: Shop) {
        Log.i("Failure Barcode Transfer")
    }
}
