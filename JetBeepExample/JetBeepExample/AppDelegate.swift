//
//  AppDelegate.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 2/26/19.
//  Copyright © 2019 Max Tymchii. All rights reserved.
//

import UIKit
import JetBeepFramework


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BackgroundController.shared.setup()
        TelemetryController.shared.startMonitoring()
        Log.setupTransferLogsFlow(.shake)
        return true
    }


    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        BackgroundController.shared.fetchData(performFetchWithCompletionHandler: completionHandler)
    }

}

