//
//  LoyaltyController.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 01.05.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import Foundation
import JetBeepFramework
import Combine

final class LoyaltyController {

    static let shared = LoyaltyController()
    var subscriptions = Set<AnyCancellable>()

    private init() {}

    func start() {
        LoyaltyManager.shared.start()

        LoyaltyManager.shared
            .barcodeStatusTransferPublisher
            .sink { event in
                switch event {
                case .success(let shop, let merchant):
                    NotificationsController.shared.triggerLocalNotification(title: "Notification was transfer successful!",
                                                                            body: String(format: "Shop: %@, merchant: %@", shop.name, merchant.name))
                case .failure(let shop, let merchant):
                    NotificationsController.shared.triggerLocalNotification(title: "Notification was transfer failure",
                                                                            body: String(format: "Shop: %@, merchant: %@", shop.name, merchant.name))
                }
            }
            .store(in: &subscriptions)
    }
}