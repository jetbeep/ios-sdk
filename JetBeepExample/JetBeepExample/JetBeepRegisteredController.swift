//
//  JetBeepRegisteredController.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 2/27/19.
//  Copyright © 2019 Max Tymchii. All rights reserved.
//

import Foundation
import JetBeepFramework
import CoreLocation
import CoreBluetooth
import UserNotifications

final class JetBeepRegisteredController: NSObject, JetBeepControllerProtocol {
    static var shared: JetBeepControllerProtocol {
        return JetBeepRegisteredController()
    }
    
    private override init() {}
    internal var peripheralManager: CBPeripheralManager!
    let locationManager: CLLocationManager! = CLLocationManager()
    private var locationsCallbackId = defaultEventSubscribeID
    private var loyaltyCallbackId = defaultEventSubscribeID
    
    func setup() {
        JetBeep.shared.devServer = true
        JetBeep.shared.registrationType = .registered
        JetBeep.shared.setup(appName: "jetbeep-test", appTokenKey: "35117dd1-a7bf-4167-b154-86626f3fac17")
        //You need go through registration process to get valid auth-token: "769b70f4-043d-4b51-a748-0f32423b6cc8"
        JetBeep.shared.appKey = "769b70f4-043d-4b51-a748-0f32423b6cc8"


        JetBeep.shared.serviceUUID = "0179c"
        JBAnalytics.shared.enabled = true
        Log.isLoggingEnabled = true
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func cacheData() {
        JetBeep.shared.sync()
            .then { _ in
                Log.i("Data cached successfully")
            }.catch { e in
                Log.e("Unable to cached data: \(e)")
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
                Log.d("Entered merchant: \(merchant.name) \(shop.name)")
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
        loyaltyCallbackId = JBBeeper.shared.subscribe { event in
            switch event {
            case .LoyaltyNotFound:
                Log.w("loyalty not found")
            case .LoyaltyTransferred(_, _, _, _):
                Log.i("loyalty transferred")
            default:
                Log.w("unhandler event")
            }
        }
    }
    
    deinit {
        JBBeeper.shared.unsubscribe(loyaltyCallbackId)
        JBLocations.shared.unsubscribe(locationsCallbackId)
    }
    
}

extension JetBeepRegisteredController: CLLocationManagerDelegate {
}

extension JetBeepRegisteredController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    }
}
