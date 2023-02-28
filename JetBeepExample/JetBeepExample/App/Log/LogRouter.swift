//
//  LogRouter.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit

protocol LogRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
	
    func openNextScreen()
}

class LogRouter {
    // MARK: - Public variables
	internal weak var viewController: UIViewController?
    
    // MARK: - Initialization
    init(viewController: UIViewController) {
		self.viewController = viewController
    }

}

extension LogRouter: LogRouterProtocol {
    func openNextScreen() {
    }

}
