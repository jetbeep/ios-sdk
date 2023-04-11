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
            .sink { event in
                switch event {
                case .entered(let shop):
                    self.enteredShop = shop.name
                    self.exitedShop = ""
                case .exited(let shop):
                    self.exitedShop = shop.name
                    self.enteredShop = ""
                @unknown default:
                    fatalError("API was updated please make changes")
                }
            }.store(in: &subscriptions)

        locationsManager
            .merchantsCallback
            .receive(on: RunLoop.main)
            .sink { event in
                switch event {
                case .entered(let merchant):
                    self.enteredMerchant = merchant.name
                    self.exitedMerchant = ""
                case .exited(let merchant):
                    self.enteredMerchant = ""
                    self.exitedMerchant = merchant.name
                @unknown default:
                    fatalError("API was updated please make changes")
                }
            }.store(in: &subscriptions)
    }
    
    // MARK: - Initialization

}

extension LocationsViewModel: LocationsViewModelProtocol {
   
}
