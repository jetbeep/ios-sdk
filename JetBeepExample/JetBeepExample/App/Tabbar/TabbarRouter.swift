//
//  TabbarRouter.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit

protocol TabbarRouterProtocol: class {
    var view: TabbarViewController? { get set }
    func openNextScreen()
}

class TabbarRouter {
    // MARK: - Public variables
    internal weak var view: TabbarViewController?
    
    // MARK: - Initialization
    init(view: TabbarViewController) {
        self.view = view
    }

}

extension TabbarRouter: TabbarRouterProtocol {
    func openNextScreen() {
    }

}
