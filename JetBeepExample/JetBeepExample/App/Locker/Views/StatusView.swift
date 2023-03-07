//
//  StatusView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 07.03.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import Foundation
import SwiftUI
import JetBeepFramework

struct StatusView: View {
    let status: Device.ConnectionState

    var body: some View {
        switch status {
        case .notConnected:
            Image(systemName: "wifi.slash")
                .foregroundColor(.red)
        case .connecting:
            Image(systemName: "wifi")
                .foregroundColor(.yellow)
                .rotationEffect(.degrees(45))
        case .connected:
            Image(systemName: "wifi")
                .foregroundColor(.green)
        }
    }
}
