//
//  VendingView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 31.03.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import SwiftUI

protocol VendingViewProtocol {
}

struct VendingView: View {
    // MARK: - Public properties
    @ObservedObject private (set) var viewModel: VendingViewModel
    @State var showModalView = false

    init (_ viewModel: VendingViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Private properties

    // MARK: - View lifecycle

    var body: some View {

        if viewModel.vendingMachines.isEmpty {
            VStack(alignment: .center) {
                Text("Please get in at vending machine working area")
            }
        } else {
            ZStack {
                scrollView
                switch viewModel.paymentViewStatus {
                case .notAvailable:
                    EmptyView()
                default:
                    paymentView
                }
            }
        }
    }

    var paymentView: some View {
        ZStack {
            BackgroundOverlay()
                .onTapGesture {

                    viewModel.paymentViewStatus = .notAvailable
                    viewModel.paymentRequest = nil
                    viewModel.disconnect()
                }

            VStack {
                Spacer()
                if let paymentRequest = viewModel.paymentRequest {
                    PaymentView(status: viewModel.paymentViewStatus, buttonTapped: viewModel.buttonTapped, paymentRequest: paymentRequest)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding()
                        .transition(.opacity)

                }
            }
        }.animation(.easeInOut(duration: 0.33))
    }

    var scrollView: some View {
        ScrollView {
            ForEach(Array(viewModel.vendingMachines.keys), id: \.deviceId) { machine in
                let status = viewModel.status(for: machine)
                VendingMachineView(title: machine.shop.name, status: status) {
                    viewModel.tap(on: machine)
                }
            }
            .padding()
        }
    }
}

// MARK: - Display logic

// MARK: - Actions

// MARK: - Overrides

// MARK: - Private functions

struct VendingView_Previews: PreviewProvider {
    static var previews: some View {
        VendingView(VendingViewModel())
    }
}

extension VendingView: VendingViewProtocol {
}
