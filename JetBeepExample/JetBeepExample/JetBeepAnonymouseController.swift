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
    private var locationsCallbackId = defaultEventSubscribeID

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
        //You can select two types of flow bluetooth or via location
        Log.d("monitoring: \(JBLocations.shared.startMonitoringFlow(.bluetooth))")
        do {
            try JBBeeper.shared.start()
        } catch {
            print(error)
        }
    }

    func subscribeOnLocationEvents() {

        locationsCallbackId = JBLocations.shared.subscribe { event in
            switch event {
            case .merchantEntered(let merchant):
                Log.d("Entered merchant: \(merchant.name)")
            case .shopEntered(let shop, _):
                Log.d("Entered shop: \(shop.name)")
            case .shopExited(let shop, _):
                Log.d("Exited shop: \(shop.name)")
            case .merchantExited(let merchant):
                Log.d("Exited merchant: \(merchant.name)")
            }
        }
    }


    func subscribeOnLoyality() {
        // we are not provide loyality cards for unregistered sdk's
    }
    
    deinit {
        JBLocations.shared.unsubscribe(locationsCallbackId)
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
