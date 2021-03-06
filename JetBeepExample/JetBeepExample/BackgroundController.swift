//
//  BackgroundController.swift
//  EasyPay
//
//  Created by Max Tymchii on 1/8/19.
//  Copyright © 2019 Syllatech. All rights reserved.
//

import Foundation
import UIKit
import JetBeepFramework
import Promises


final class BackgroundController {
    private init() {}
    static let shared = BackgroundController()
    
    /**
     Setup time of background fetch ones per 12 hours ==> 12h * 60m * 60s = 43200
     for testing you can set UIApplicationBackgroundFetchIntervalMinimum
     */
    func setup() {
        UIApplication.shared.setMinimumBackgroundFetchInterval(43200)
    }
    
    func fetchData(performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        all(JetBeep.shared.sync(), TelemetryController.shared.forceTelemetrySynchronization())
            .then { _ in
                Log.d("cached successfully")
                completionHandler(.newData)
            }
            .catch { e in
                completionHandler(.failed)
                Log.w("unable to cache: \(e)")
        }
    }
}
