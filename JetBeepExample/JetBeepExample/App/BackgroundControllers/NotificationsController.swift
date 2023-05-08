//
//  NotificationsController.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 26.04.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import Foundation
import UserNotifications
import JetBeepFramework
import Combine

class NotificationsController {
    
    static let shared = NotificationsController()
    private var subscriptions: Set<AnyCancellable> = []
    private let notificationsManager = NotificationsManager()
    
    private init() {
    }
    
    func execute() {
        requestNotificationAuthorization()
        subscribeOnEvents()
    }

    private func subscribeOnEvents() {
        notificationsManager.start()

        notificationsManager.notificationPublisher.sink { event in
            switch event {
            case .ready(notification: let notification, merchant: _, shop: _):
                self.triggerLocalNotification(title: notification.title, body: notification.subtitle)
            case .cancel:
                break
            }
        }.store(in: &subscriptions)
    }

    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }

    func triggerLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error triggering notification: \(error.localizedDescription)")
            }
        }
    }
}
