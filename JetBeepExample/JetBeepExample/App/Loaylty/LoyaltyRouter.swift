//
//  LoyaltyRouter.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 15.03.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit

protocol LoyaltyRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }

    func openNextScreen()
}

class LoyaltyRouter {
    // MARK: - Public variables
	internal weak var viewController: UIViewController?

    // MARK: - Initialization
    init(viewController: UIViewController) {
		self.viewController = viewController
    }

}

extension LoyaltyRouter: LoyaltyRouterProtocol {
    func openNextScreen() {
        let addUserNumbersViewController = AddUserNumbersConfigurator().makeViewController().0
        viewController?.navigationController?.pushViewController(addUserNumbersViewController, animated: true)

    }

}
