//
//  Color+extension.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.03.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import Foundation
import SwiftUI


extension UIColor {
    convenience init(hex: Int) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 08) & 0xff) / 255,
            blue: CGFloat((hex >> 00) & 0xff) / 255,
            alpha: CGFloat(1.0)
        )
    }

    func toColor() -> Color {
        return Color(self)
    }


}

extension UIColor {
    static let primaryColor = UIColor(hex: 0x0E2B79)
    static let complementaryColor = UIColor(hex: 0x00F6FF)
    static let secondaryColor = UIColor(hex: 0x9FA2AB)
}
