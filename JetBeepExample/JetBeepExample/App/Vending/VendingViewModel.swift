//
//  VendingViewModel.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 31.03.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import Foundation
import SwiftUI
import JetBeepFramework
import Combine

class VendingViewModel: ObservableObject {
    // MARK: - Public variables
    var router: VendingRouterProtocol!
    @Published var vendingMachines: [JetbeepDevice: VendingManager.Status] = [:]
    @Published var paymentRequest: PaymentRequest?
    @Published var paymentViewStatus: PaymentView.PaymentStatus = .notAvailable

    var buttonTapped = PassthroughSubject<Bool, Never>()

    // MARK: - Private variables
    private var eventSubscriber: AnyCancellable?
    private var subscription: Set<AnyCancellable> = []

    init() {
        VendingManager.shared.start()

        eventSubscriber = VendingManager.shared.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { newEvent in
                self.update(newEvent)
                self.objectWillChange.send()
            }

        buttonTapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] flag in

                guard flag else {
                    return
                }

                self?.paymentFlow()
            }
            .store(in: &subscription)

    }

    private func update(_ status: VendingManager.Status) {
        Log.i("New status \(status)")
        switch status {
        case .found(let device):
            add(device, with: status)
        case .lost(let device):
            remove(device)
        case .connectable(let device),
                .connecting(let device),
                .connected(let device),
                .unavailable(let device):
            Log.i("Payment status \(status)")
            vendingMachines[device] = status
        case .disconnected(let device), .paymentFailure(let device):
            Log.i("Payment canceled")
            paymentViewStatus = .notAvailable
            vendingMachines[device] = status
            disconnect()
        case .paymentInitiated(let device, let paymentRequest):
            vendingMachines[device] = status
            self.paymentRequest = paymentRequest
            paymentViewStatus = .readyToPay
        case .paymentSuccess(let device, _):
            vendingMachines[device] = status
        case .paymentCanceled(let device, _):
            paymentViewStatus = .notAvailable
            vendingMachines[device] = status
            disconnect()
        }
    }

    func tap(on vendingMachine: JetbeepDevice) {
        guard let status = vendingMachines[vendingMachine] else {
            return
        }

        switch status {
        case .connectable(let device):
            connect(to: device)
        default:
            disconnect()
        }
    }

    private func paymentFlow() {
        guard let paymentRequest = paymentRequest else {
            Log.i("Payment request is nil")
            return
        }
        paymentViewStatus = .inProgress
        Task {
            do {
                let paymentProcessor = try VendingPaymentProcessor(paymentRequest: paymentRequest)
                try await VendingManager.shared.apply(paymentProcessor: paymentProcessor)
                await MainActor.run {
                    paymentViewStatus = .success
                }
            } catch {
                Log.i("An error occurred \(error)")
                await MainActor.run {
                    paymentViewStatus = .failure(error)
                }
            }

        }
    }

    func disconnect() {
        Task {
            try? await VendingManager.shared.disconnect()
        }
    }

    func status(for device: JetbeepDevice) -> VendingManager.Status {
        let machine = vendingMachines.first { $0.key.deviceId == device.deviceId }
        guard machine != nil,
              let status = vendingMachines[device]
        else {
            fatalError("Missing device!")
        }

        return status

    }

    private func add(_ device: JetbeepDevice, with status: VendingManager.Status) {
        vendingMachines[device] = status
    }

    private func remove(_ device: JetbeepDevice) {
        vendingMachines[device] = nil
    }

    func connect(to device: JetbeepDevice) {
        Task {
            do {
                try await VendingManager.shared.connect(to: device)
            } catch {
                Log.i("Error \(error)")
            }
        }
    }

    deinit {
        VendingManager.shared.stop()
        eventSubscriber?.cancel()
    }

}
