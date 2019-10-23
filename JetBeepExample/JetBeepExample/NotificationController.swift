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
import Promises

final class NotificationController {
    static let shared = NotificationController()
    private init() {}
    private var callbackID = 0
    
    func subscribeOnPushNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            // Enable or disable features based on authorization.
            if let e = error {
                Log.i("Request push notification authorization failed! \(e)")
            } else {
                Log.i("Request push notification authorization succeed!")
            }
            self.execute()
        }
        
    }

    func execute() {
        callbackID = NotificationDispatcher.shared.subscribe { event in
               switch event {
               case .ready(let model):
                   let logMessage = "Show notification for merchant \(model.merchantId)"
                   Log.i(logMessage)
                   
                   all(model.merchant, model.info)
                       .then{ result, info in
                           guard let merchant = result else {
                               Log.i("Didn't parse")
                               return
                           }
                           Log.i("\(merchant) + \(info)")
                           self.entered(merchant: merchant, info: info)
                   }
               case .cancel(let model):
                   UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [model.id])
                   let logMessage = "Exit from merchant \(model.merchantId) modelId\(model.id)"
                   Log.i(logMessage)
               }
           }
       }
       
       private func exit(from notification: NotificationModel) {
           UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notification.id])
       }
       
       private func entered(merchant: Merchant, info: NotificationInfo) {
        let sound = info.isSilentPush ? nil : "default"
        BaseNotification(withIdentifier: info.id, withCategoryId: "Test", withTitle: info.title, withMessage: info.subtitle, withCustomSound: sound).show()
       }
       
    deinit {
        NotificationDispatcher.shared.unsubscribe(callbackID)
    }
}
