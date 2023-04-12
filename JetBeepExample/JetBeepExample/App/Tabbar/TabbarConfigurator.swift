//
//  TabbarConfigurator.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit

protocol TabbarConfiguratorProtocol: AnyObject {
    func makeViewController() -> TabbarViewController
    func config(viewController: TabbarViewController)
}

class TabbarConfigurator {
}

extension TabbarConfigurator: TabbarConfiguratorProtocol {
    func makeViewController() -> TabbarViewController {
        let viewController = TabbarViewController()
        viewController.configurator = self
        config(viewController: viewController)
        viewController.setupConfig()
        viewController.setupControllers()
        return viewController
    }

    func config(viewController: TabbarViewController) {
        let router = TabbarRouter(view: viewController)
        let presenter = TabbarPresenter(router: router, view: viewController)
        viewController.presenter = presenter
    }

}
