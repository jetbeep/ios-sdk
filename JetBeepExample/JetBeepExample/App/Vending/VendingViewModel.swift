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

protocol VendingViewModelProtocol: AnyObject {

}

class VendingViewModel: ObservableObject {
    // MARK: - Public variables
 

    // MARK: - Private variables
    var router: VendingRouterProtocol!
    @Published var vendingMachines: [JetbeepDevice] = []

    private var devicesSubscriber: AnyCancellable?
    private var connectionStatusSubscriber: AnyCancellable?
    
    init() {
        VendingManager.shared.start()
        devicesSubscriber = VendingManager
            .shared
            .devicesCallback
            .receive(on: DispatchQueue.main)
            .sink { event in
                self.vendingMachines = VendingManager.shared.foundDevices
            }

        connectionStatusSubscriber = VendingManager.shared
            .connectionStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { newStatus in
                self.vendingMachines = VendingManager.shared.foundDevices
            })


    }

    func connect(to device: JetbeepDevice) {
        Task {
            do {
                try await VendingManager.shared.connect(to: device)
            } catch {
                print("Error \(error)")
            }
        }
    }

    deinit {
        VendingManager.shared.stop()
        devicesSubscriber?.cancel()
        connectionStatusSubscriber?.cancel()
    }

    func status(for device: JetbeepDevice) -> VendingMachineView.VendingMachineStatus {
        if !device.state.contains(.driverMode) {
            return .unavailable
        }
        
        if !device.state.contains(.connectable) {
            return .unavailable
        }

        switch device.state {
        case .paymentCreated:
            return .waitingForPayment
        case .openedSession:
            return .connected
        case .connectable:
            switch device.connectionState {
            case .connecting:
                return .connecting
            case .notConnected:
                return .notConnected
            default:
                break;
            }
        default:
            return .notConnected
        }

        return .notConnected
    }

}

extension VendingViewModel: VendingViewModelProtocol {
   
}
