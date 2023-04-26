//
//  TabbarViewController.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import UIKit

protocol TabbarViewProtocol: AnyObject {
    func showToast(message: String)
}

class TabbarViewController: UITabBarController {
    // MARK: - Public properties
    var presenter: TabbarPresenterProtocol?
    var configurator: TabbarConfiguratorProtocol?

    // MARK: - Private properties

    // MARK: - View lifecycle

    func setupConfig() {
        presenter?.setup()
        presenter?.cacheData()
    }

    func setupControllers() {

        view.backgroundColor = .red
        viewControllers = presenter?.instantiateViewControllers()
        delegate = self
    }

    // MARK: - Display logic

    // MARK: - Actions

    // MARK: - Overrides

    // MARK: - Private functions

}

extension TabbarViewController: UITabBarControllerDelegate {

}

extension TabbarViewController: TabbarViewProtocol {
    func showToast(message: String) {
        showErrorToast(message: message)
    }
}
