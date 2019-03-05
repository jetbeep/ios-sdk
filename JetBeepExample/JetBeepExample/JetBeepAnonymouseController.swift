//
//  JetBeepAnonymouseController
//  JetBeepExample
//
//  Created by Max Tymchii on 2/26/19.
//  Copyright © 2019 Max Tymchii. All rights reserved.
//

import Foundation
import JetBeepFramework
import CoreLocation
import CoreBluetooth

final class JetBeepAnonymouseController: NSObject, JetBeepControllerProtocol {

    static var shared: JetBeepControllerProtocol {
        get {
            return JetBeepAnonymouseController()
        }
    }

    private override init() {}
    let barcodeHandler = JetBeepBarcodeHandler()
    internal var peripheralManager: CBPeripheralManager!
    let locationManager: CLLocationManager! = CLLocationManager()

    func setup() {
        JetBeep.shared.devServer = true
        JetBeep.shared.registrationType = .anonymous
        JetBeep.shared.setup(appName: "jetbeep-test-2", appTokenKey: "6538c072-bf9e-41f6-96fc-d6de16f46fa0")
        JetBeep.shared.serviceUUID = "0179e"
        JetBeep.shared.barcodeRequestHandler = barcodeHandler
        barcodeHandler.delegate = self
        JBAnalytics.shared.enabled = true
        Log.isLoggingEnabled = true

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
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
        Log.d("monitoring: \(JBLocations.shared.startMonitoring())")
        do {
            try JBBeeper.shared.start()
        } catch {
            print(error)
        }
    }

    func subscribeOnLocationEvents() {

        let _ = JBLocations.shared.subscribe { event in
            switch event {
            case .MerchantEntered(let merchant):
                Log.d("Entered merchant: \(merchant.name)")
                NotificationController.shared.showNotification(title: "Entered merchant", body: "\(merchant.name)")
            case .ShopEntered(let shop, _):
                Log.d("Entered shop: \(shop.name)")
                NotificationController.shared.showNotification(title: "Entered shop", body: "\(shop.name)")
            case .ShopExited(let shop, _):
                Log.d("Exited shop: \(shop.name)")
                NotificationController.shared.showNotification(title: "Exited shop", body: "\(shop.name)")
            case .MerchantExited(let merchant):
                Log.d("Exited merchant: \(merchant.name)")
                NotificationController.shared.showNotification(title: "Exited merchant", body: "\(merchant.name)")
            }
        }
    }


    func subscribeOnLoyality() {
        // we are not provide loyality cards for unregistered sdk's
    }
    
}

extension JetBeepAnonymouseController: CLLocationManagerDelegate {
}

extension JetBeepAnonymouseController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
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
