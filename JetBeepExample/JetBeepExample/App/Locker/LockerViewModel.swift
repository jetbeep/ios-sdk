//
//  LockerViewModel.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import JetBeepFramework

extension LockerDevice: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(device.deviceId)
        hasher.combine(device.shopId)
    }

    public static func == (lhs: JetBeepFramework.LockerDevice, rhs: JetBeepFramework.LockerDevice) -> Bool {
        return lhs.device.deviceId == rhs.device.deviceId
    }

    var title: String {
        return "Device id: \(device.deviceId) at: \(device.shop.name)"
    }

    var subtitle: String {
        return device
            .lockers?
            .lockStatuses
            .compactMap { $0 == .closed ? "X" : "O" }
            .lazy
            .joined(separator: " ") ?? ""
    }
}

protocol LockerViewModelProtocol: AnyObject {
    func startSearch()
    func stopSearch()
    func applyToken()
}

class LockerViewModel: ObservableObject {
    // MARK: - Public variables

    @Published var tokenInput: String = ""
    @Published var tokenResult: String = ""
    @Published var deviceNearby: [LockerDevice] = []

    var inputTokenPublisher = PassthroughSubject<String, Never>()

    private var subscriptions: Set<AnyCancellable> = []

    var isApplyButtonEnabled: Bool {
        return createTokenFromInputField() != nil ? true : false
    }

    // MARK: - Private variables
    var router: LockerRouterProtocol!

    // MARK: - Initialization
    init() {
    }

    private func deviceNearbyInfo() -> String {
        var string = "Nearby devices:\n"

        let lockersInfo = LockerManager
            .shared
            .devicesNearby
            .compactMap { device in
                String("Id: \(device.device.deviceId) name:\(device.device.shop.name) statuses \(device.device.lockers?.lockStatuses)")
            }
            .joined(separator: "\n")

        string.append(lockersInfo)

        return string
    }

    private func createTokenFromInputField() -> Token? {
        if !tokenInput.isEmpty,
           let token = TokenGenerator.create(hex: tokenInput) {
            return token
        }
        return nil
    }

}

extension LockerViewModel: LockerViewModelProtocol {
    func applyToken() {
        guard let token = createTokenFromInputField() else {
            return
        }
        tokenResult = ""
        Task {
            do {
                let result = try await LockerManager
                    .shared
                    .apply(token)
                    .result
                    .toHexString()

                DispatchQueue.main.async {
                    self.tokenResult = result
                }

            } catch {
                Log.i("Apply finished with error \(error)")
            }
        }
    }

    func stopSearch() {
        LockerManager.shared.stop()
        eraseTokenField()
        eraseTokenResultField()
        deviceNearby = []
    }

    func startSearch() {

        LockerManager.shared.start()
        LockerManager.shared
            .lockersStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] signal in
                print("New status \(signal)")
                self?.deviceNearby = LockerManager.shared.devicesNearby
            }.store(in: &subscriptions)

        
        if let token = createTokenFromInputField() {
            LockerManager.shared.start(with: [token])
        } else {
            LockerManager.shared.start(with: [])
        }

    }

    func eraseTokenField() {
        tokenInput = ""
    }

    func eraseTokenResultField() {
        tokenResult = ""
    }

}
