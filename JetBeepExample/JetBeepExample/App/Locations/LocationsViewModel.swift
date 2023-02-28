//
//  LocationsViewModel.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import JetBeepFramework

protocol LocationsViewModelProtocol: AnyObject {

}

class LocationsViewModel: ObservableObject {
    // MARK: - Public variables

    private var subscriptions: Set<AnyCancellable> = []
    // MARK: - Private variables
    var router: LocationsRouterProtocol!
    let locationsManager = LocationsManager()

    @Published var enteredShop = ""
    @Published var enteredMerchant = ""
    @Published var exitedShop = ""
    @Published var exitedMerchant = ""

    var nearbyShops: String {
        return locationsManager
            .shopsNearby
            .compactMap {$0.name}
            .joined(separator: ",")
    }

    var nearbyMerchants: String {
        return locationsManager
            .merchantsNearby
            .compactMap {$0.name}
            .joined(separator: ",")
    }

    init() {
        locationsManager.start()

        subscribeToPublishers()
    }

    private func subscribeToPublishers() {

        locationsManager
            .shopsCallback
            .receive(on: RunLoop.main)
            .sink { signal in
                switch signal.event {
                case .entered:
                    self.enteredShop = signal.shop.name
                    self.exitedShop = ""
                case .exited:
                    self.exitedShop = signal.shop.name
                    self.enteredShop = ""
                @unknown default:
                    fatalError("API was updated please make changes")
                }
            }.store(in: &subscriptions)

        locationsManager
            .merchantsCallback
            .receive(on: RunLoop.main)
            .sink { signal in
                switch signal.event {
                case .entered:
                    self.enteredMerchant = signal.merchant.name
                    self.exitedMerchant = ""
                case .exited:
                    self.enteredMerchant = ""
                    self.exitedMerchant = signal.merchant.name
                @unknown default:
                    fatalError("API was updated please make changes")
                }
            }.store(in: &subscriptions)
    }
    
    // MARK: - Initialization

}

extension LocationsViewModel: LocationsViewModelProtocol {
   
}
