//
//  AddUserNumbersRouter.swift
//  Pods
//
//  Created by Max Tymchii on 28.03.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddUserNumbersRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }

    func openNextScreen()
}

class AddUserNumbersRouter {
    // MARK: - Public variables
	internal weak var viewController: UIViewController?

    // MARK: - Initialization
    init(viewController: UIViewController) {
		self.viewController = viewController
    }

}

extension AddUserNumbersRouter: AddUserNumbersRouterProtocol {
    func openNextScreen() {
    }

}
