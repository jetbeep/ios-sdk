//
//  VendingRouter.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 31.03.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit

protocol VendingRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }

    func openNextScreen()
}

class VendingRouter {
    // MARK: - Public variables
	internal weak var viewController: UIViewController?

    // MARK: - Initialization
    init(viewController: UIViewController) {
		self.viewController = viewController
    }

}

extension VendingRouter: VendingRouterProtocol {
    func openNextScreen() {
    }

}
