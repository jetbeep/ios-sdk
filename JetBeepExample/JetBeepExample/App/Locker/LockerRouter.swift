//
//  LockerRouter.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit

protocol LockerRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }

    func openNextScreen()
}

class LockerRouter {
    // MARK: - Public variables
	internal weak var viewController: UIViewController?

    // MARK: - Initialization
    init(viewController: UIViewController) {
		self.viewController = viewController
    }

}

extension LockerRouter: LockerRouterProtocol {
    func openNextScreen() {
    }

}
