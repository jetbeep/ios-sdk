//
//  NotificationController.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 3/5/19.
//  Copyright © 2019 Max Tymchii. All rights reserved.
//

import Foundation
import UserNotifications
import JetBeepFramework

final class NotificationController {
    static let shared = NotificationController()
    private init() {}
    
    func subscribeOnPushNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            // Enable or disable features based on authorization.
            if let e = error {
                Log.i("Request push notification authorization failed! \(e)")
            } else {
                Log.i("Request push notification authorization succeed!")
            }
        }
    }

    func showNotification(title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "notify-test" + title
        let request = UNNotificationRequest.init(identifier: content.title, content: content, trigger: nil)

        center.add(request)
    }
}
