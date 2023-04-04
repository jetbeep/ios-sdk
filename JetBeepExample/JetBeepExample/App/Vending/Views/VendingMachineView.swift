//
//  VendingMachineView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 31.03.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import SwiftUI

struct VendingMachineView: View {
    let title: String
    let status: VendingMachineStatus
    var completion: (() -> ())? = nil

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(status.title.appending(status.icon))
            }
            Spacer()
            Button(action: {
                completion?()
            }) {
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
        .disabled(status == .unavailable)

    }

    enum VendingMachineStatus {
        case unavailable
        case notConnected
        case connecting
        case connected
        case disconnecting
        case waitingForPayment
        case paymentInProgress
        case cooking
        case done

        var title: String {
            switch self {
            case .unavailable:
                return "Unavailable"
            case .notConnected:
                return "Available for connection"
            case .connected:
                return "Select a drink"
            case .waitingForPayment:
                return "Waiting for payment..."
            case .paymentInProgress:
                return "Payment in progress..."
            case .cooking:
                return "Cooking..."
            case .done:
                return "Done!"
            default:
                return ""
            }
        }

        var buttonTitle: String {
            switch self {
            case .notConnected, .unavailable:
                return "Connect"
            default:
                return "Disconnect"
            }
        }

        var buttonColor: Color {
            switch self {
            case .unavailable:
                return Color.gray
            default:
                return Color.green
            }
        }


        var icon: String {
            switch self {
            case .unavailable:
                return "🚫❌🙅‍♀️"
            case .notConnected:
                return "🔌🚫❌"
            case .connecting:
                return "🔍🔄💬"
            case .connected:
                return "🔵✅🟢"
            case .disconnecting:
                return "🙅🏼‍♂️🔌👋🏼"
            case .waitingForPayment:
                return "⏳💸🤔"
            case .paymentInProgress:
                return "💳💰🕰️"
            case .cooking:
                return "🍳🍔🍟"
            case .done:
                return "🎉👍🏼✅"
            }
        }

    }
}


struct VendingMachineView_Previews: PreviewProvider {
    static var previews: some View {
        VendingMachineView(title: "Custom vending machine", status:  .waitingForPayment)
    }
}
