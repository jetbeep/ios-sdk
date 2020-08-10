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
        JetBeep.shared.devServer = false
        JetBeep.shared.registrationType = .anonymous
        JetBeep.shared.setup(appName: "fishka", appTokenKey: "6f42b634-471e-4b7f-9eef-0e110ee7b2b9")
        JetBeep.shared.serviceUUID = "017a0"
        JBLocations.shared.startMonitoringFlow(.bluetooth)
        JetBeep.shared.barcodeRequestHandler = barcodeHandler
        barcodeHandler.delegate = self

        Log.isLoggingEnabled = true

//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        JBAnalytics.shared.enabled = false
    }

    func cacheData() {
        JetBeep.shared.sync()
            .then { _ in
                Log.d("cached successfully")
            }.catch { e in
                Log.w("!!!!!unable to cache: \(e)")
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
            case .merchantEntered(let merchant, let shop):
                Log.d("Entered merchant: \(merchant.name) \(shop.id) \(shop.domainId)")
            case .shopEntered(let shop, _):
                Log.d("Entered shop: \(shop.name) \(shop.id) \(shop.domainId)")
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
