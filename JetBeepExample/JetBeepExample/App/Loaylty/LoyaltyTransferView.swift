//
//  LoyaltyTransferView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 15.03.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import SwiftUI


struct LoyaltyTransferView: View {
    let status: LoyaltyViewModel.LoyaltyTransferStatus
    @State var shouldAnimate = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.clear)
                .shadow(radius: 10)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 119/255, green: 208/255, blue: 192/255), Color(red: 28/255, green: 66/255, blue: 139/255)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .aspectRatio(16/9, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .cornerRadius(20)

            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(imageColor)

                Text(statusText)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
            }
        }
        .animation(shouldAnimate ? .default : nil)
        .onAppear {
            shouldAnimate = true
        }
    }

    private var backgroundColor: Color {
        switch status {
        case .success:
            return Color.green
        case .failure:
            return Color.red
        case .waiting:
            return Color.yellow
        }
    }

    private var imageName: String {
        switch status {
        case .success:
            return "checkmark.circle"
        case .failure:
            return "xmark.circle"
        case .waiting:
            return "hourglass"
        }
    }

    private var imageColor: Color {

        switch status {
        case .success:
            return Color(red: 17/255, green: 176/255, blue: 91/255)
        case .failure:
            return Color(red: 255/255, green: 63/255, blue: 52/255)
        case .waiting:
            return Color.yellow
        }

    }

    private var statusText: String {
        switch status {
        case .success:
            return "Loyalty transferred successfully"
        case .failure:
            return "Loyalty transfer failed"
        case .waiting:
            return "Waiting for loyalty transfer"
        }
    }

    private var textColor: Color {
        switch status {
        case .waiting:
            return .black
        default:
            return .white
        }
    }
}
