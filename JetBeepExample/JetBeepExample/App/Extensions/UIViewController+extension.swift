//
//  UIViewController+extension.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 26.04.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func showErrorToast(message: String, duration: TimeInterval = 5) {
        guard let window = UIApplication.shared.windows.first else { return }

        let toastView = ErrorToastView(message: message)
        window.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            toastView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 16),
            toastView.widthAnchor.constraint(lessThanOrEqualTo: window.widthAnchor, multiplier: 0.8)
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            toastView.removeFromSuperview()
        }
    }
}
