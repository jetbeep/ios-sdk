import Foundation
import UserNotifications
import UIKit

class BaseNotification {
    
    let identifier: String
    let categoryId: String
    let title: String
    let message: String
    let customSound: String?
    let userInfo: [AnyHashable : Any]?
    
    
    private static var _notificationCounter = 0
    static var notificationCounter: Int {
        _notificationCounter += 1
        return _notificationCounter
    }

    var notificationIdentifier: String {
        return identifier
    }

    init(withIdentifier: String, withCategoryId: String, withTitle: String, withMessage: String, withCustomSound: String? = nil, withActions: [UNNotificationAction] = [], withUserInfo: [AnyHashable : Any]? = nil) {
        categoryId = withCategoryId
        title = withTitle
        message = withMessage
        identifier = withIdentifier
        customSound = withCustomSound
        userInfo = withUserInfo
    }
    
    func show() {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.categoryIdentifier = categoryId
        if let userInfo = userInfo {
            content.userInfo = userInfo
        }
        
        if let sound = customSound {
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: sound))
        }
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        let center = UNUserNotificationCenter.current()
        
        let category = UNNotificationCategory(identifier: categoryId, actions: [], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        
        center.add(request) { (error) in
            print(error ?? "error")
        }
    }
    
    func handleAction(actionId: String, completionHandler: @escaping () -> Void) {
        assert(false, "should override this method")
    }

    var parametersDictionary: [AnyHashable : Any]? {
        return userInfo
    }
}
