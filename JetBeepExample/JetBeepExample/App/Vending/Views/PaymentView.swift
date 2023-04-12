//
//  PaymentView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 05.04.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import SwiftUI
import JetBeepFramework
import Combine

protocol PaymentViewModelProtocol {
    var shopName: String { get }
    var amount: UInt32 { get }
}

extension PaymentRequest: PaymentViewModelProtocol {
    var shopName: String {
        return shop.name
    }

}

struct FakePayment: PaymentViewModelProtocol {
    var shopName: String = "Fake Shop"
    var amount: UInt32 = 100
}

struct BackgroundOverlay: View {
    var body: some View {
        Color.black.opacity(0.4)
            .edgesIgnoringSafeArea(.all)
    }
}

struct PaymentView: View {

    enum PaymentStatus {
        case notAvailable
        case readyToPay
        case inProgress
        case success
        case failure(Error)
    }

    var status: PaymentStatus = .notAvailable
    var buttonTapped: PassthroughSubject<Bool, Never>

    @Environment(\.presentationMode) var presentationMode
    var paymentRequest: PaymentViewModelProtocol

    var body: some View {

        VStack(alignment: .center) {

            Text(paymentRequest.shopName)
                .font(.largeTitle)
                .padding(.top)

            Image("coffee-icon")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 160, height: 160)

            Text("Price: \(Double(paymentRequest.amount) / 100, specifier: "%.2f")")
                .font(.title)
            switch status {
            case .readyToPay:
                paymentButton
            case .inProgress:
                spinner
            case .success:
                successImage
            case .failure(let error):
                failureImage
                failureMessage(error.localizedDescription)
            case .notAvailable:
                EmptyView()
            }
        }.frame(maxWidth: .infinity)
    }

    var spinner: some View {

        if #available(iOS 14.0, *) {
            return ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        }

        return EmptyView()
    }

    var paymentButton: some View {
        Button {
            buttonTapped.send(true)
        } label: {
            if #available(iOS 14.0, *) {
                HStack(alignment: .center) {
                    Image("jetbeep-logo")
                        .resizable()
                        .frame(maxWidth: 14, maxHeight: 25)
                        .scaledToFit()
                        .clipped()

                    Text("Pay")
                        .font(.title2)
                        .padding()

                }
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                // Fallback on earlier versions
            }
        }
        .padding()
    }

    var successImage: some View {
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .foregroundColor(.green)
            .padding()
    }

    var failureImage: some View {
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .foregroundColor(.red)

    }

    func failureMessage(_ message: String) -> some View {
        Text(message)
            .font(.body)
            .lineLimit(3)
            .frame(width: .infinity)
            .padding()
    }

}

struct PaymentContainerView: View {
    @State private var showModal = false
    var buttonTapped = PassthroughSubject<Bool, Never>()

    var body: some View {
        ZStack {
            VStack {
                Button("Show Modal") {
                    showModal = true
                }
            }

            if showModal {
                BackgroundOverlay()
                    .onTapGesture {
                        showModal = false
                    }
                VStack {
                    Spacer()
                    PaymentView(buttonTapped: buttonTapped, paymentRequest: FakePayment()) //
                        .frame(width: .infinity, height: 400)
                        .background(Color.white)
                        .cornerRadius(16)
                        .transition(.opacity)
                        .padding()
                }
            }
        }
        .animation(.easeInOut(duration: 0.33))
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentContainerView()
    }
}
