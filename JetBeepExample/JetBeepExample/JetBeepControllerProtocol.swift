//
//  JetBeepControllerProtocol.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 2/27/19.
//  Copyright © 2019 Max Tymchii. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth


protocol JetBeepControllerProtocol: NSObjectProtocol {
    var peripheralManager: CBPeripheralManager! {get}
    var locationManager: CLLocationManager! {get}
    func setup()
    func cacheData()
    func startMonitoring()
    func subscribeOnLocationEvents()
    func subscribeOnLoyality()
    static var shared: JetBeepControllerProtocol {get}
}

