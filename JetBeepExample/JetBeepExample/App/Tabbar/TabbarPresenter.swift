//
//  TabbarPresenter.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit
import JetBeepFramework

protocol TabbarPresenterProtocol: AnyObject {
    var view: TabbarViewProtocol? { get set }
    func instantiateViewControllers() -> [UIViewController]
    func setup()
    func cacheData()
}

class TabbarPresenter {
    // MARK: - Public variables
    internal weak var view: TabbarViewProtocol?

    // MARK: - Private variables
    private let router: TabbarRouterProtocol

    // MARK: - Initialization
    init(router: TabbarRouterProtocol, view: TabbarViewProtocol) {

        self.router = router
        self.view = view
    }
    func setup() {
        let appNameKey = "jetbeep-demo-app"
        let appToken = "50ef7956-f6d0-4524-a4db-7e33f51f0296"
        let serviceUUID = "017af"

        JetBeep.shared.serverType = .production
        JetBeep.shared.registrationType = .anonymous
        JetBeep.shared.setup(appName: appNameKey, appTokenKey: appToken)
        JetBeep.shared.serviceUUID = serviceUUID
        JetBeep.shared.userNumbers = Storage.userNumbers

        Log.isLoggingEnabled = true

        // Start advertising
        do {
            try JBBeeper.shared.start()
        } catch {
            print(error)
        }
    }

    func cacheData() {
        JetbeepTaskManager.shared.addAsyncTask {
            do {
                try await JetBeep.shared.sync()
                Log.d("cached successfully")
            } catch {
                Log.w("unable to cache: \(error)")
            }
        }

    }

}

extension TabbarPresenter: TabbarPresenterProtocol {
    func instantiateViewControllers() -> [UIViewController] {
        return [
                LocationsConfigurator().makeViewController().0,
                LockerConfigurator().makeViewController().0,
                LoyaltyConfigurator().makeViewController().0,
                VendingConfigurator().makeViewController().0,
                LogConfigurator().makeViewController().0]
    }

}
