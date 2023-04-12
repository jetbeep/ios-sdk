//
//  VendingMachineView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 31.03.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import SwiftUI
import JetBeepFramework

extension VendingManager.Status {

    var isDisabled: Bool {
        switch self {
        case .unavailable, .disconnected, .lost:
            return true
        default:
            return false
        }
    }

}

extension VendingManager.Status {
    var title: String {
        switch self {
        case .found:
            return "Found 🔍📍📡"
        case .unavailable:
            return "Unavailable ❌⚠️🚫"
        case .connectable:
            return "Connectable 🔄📶🔁"
        case .connecting:
            return "Connecting ⏳🔄⌛️"
        case .connected:
            return "Connected ✅🔗🌐"
        case .disconnected:
            return "Disconnected 🔌❌⛔️"
        case .paymentInitiated:
            return "Waiting for Payment 💸⌛️💳"
        case .paymentSuccess:
            return "Payment Success 💰✅🎉"
        case .paymentFailure:
            return "Payment Failure ❗️❌⚠️"
        case .lost:
            return "Lost 🔍❓🔎"
        case .paymentCanceled:
            return "Payment canceled 💸💳❌"
        }
    }

    var buttonTitle: String {
        switch self {
        case .connectable:
            return "Connect"
        default:
            return "Disconnect"
        }
    }

    var buttonColor: Color {
        switch self {
        case .connectable:
            return .green
        default:
            return .gray
        }
    }
}

struct VendingMachineView: View {
    let title: String
    let status: VendingManager.Status
    var completion: (() -> Void)?

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(status.title)
            }
            Spacer()
            Button {
                completion?()
            } label: {
                Text(status.buttonTitle)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(status.buttonColor)
            .cornerRadius(8)

        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
        .disabled(status.isDisabled)

    }

}

// struct VendingMachineView_Previews: PreviewProvider {
//    static var previews: some View {
//        VendingMachineView(title: "Custom vending machine", status: .unavailable(<#T##JetbeepDevice#>))
//    }
// }
