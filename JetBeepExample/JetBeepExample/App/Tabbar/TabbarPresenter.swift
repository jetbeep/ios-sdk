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
        let appNameKey = "gls-app"
        let appToken = "4db96549-ea58-4cc1-bb5c-4ee9de416585"
        let serviceUUID = "017a7"

        JetBeep.shared.serverType = .production
        JetBeep.shared.registrationType = .anonymous
        JetBeep.shared.setup(appName: appNameKey, appTokenKey: appToken)
        JetBeep.shared.serviceUUID = serviceUUID

//        JetBeep.shared.barcodeRequestHandler = barcodeHandler
//        barcodeHandler.delegate = self
//        AnalyticsManager.shared.start()

        Log.isLoggingEnabled = true

        //Start advertising
        do {
            try JBBeeper.shared.start()
        } catch {
            print(error)
        }
    }



    func cacheData() {
        JetBeep.shared.sync()
            .then { _ in
                Log.d("cached successfully")
            }.catch { e in
                Log.w("unable to cache: \(e)")
        }

    }

}

extension TabbarPresenter: TabbarPresenterProtocol {
    func instantiateViewControllers() -> [UIViewController] {
        return [
                LocationsConfigurator().makeViewController().0,
                LockerConfigurator().makeViewController().0,
                LogConfigurator().makeViewController().0]
    }
    
}
