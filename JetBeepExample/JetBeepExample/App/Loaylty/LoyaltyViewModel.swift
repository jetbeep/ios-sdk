//
//  LoyaltyViewModel.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 15.03.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import JetBeepFramework
import Promises

extension TimeInterval {
    var days: Int {
        return Int(self / (60 * 60 * 24))
    }
}

extension Offer: OfferViewProtocol {

    var subtitle: String {
        return description ?? ""
    }

    var thumbnailUrl: String? {
        return imageURL
    }

    var daysLeft: Int? {
        return endDate.timeIntervalSince(startDate).days
    }

    var isPersonalised: Bool {
        return personalOffer
    }

}

extension Offer: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Offer, rhs: Offer) -> Bool {
        return lhs.id == rhs.id
    }
}

protocol LoyaltyViewModelProtocol: AnyObject {

}

class LoyaltyViewModel: ObservableObject {
    // MARK: - Public variables

    enum LoyaltyTransferStatus {
        case success
        case failure
        case waiting
    }

    // MARK: - Private variables
    @Published var status: LoyaltyTransferStatus = .waiting
    @Published var offers: [Offer] = []

    private var subscriptions = Set<AnyCancellable>()
    var router: LoyaltyRouterProtocol!

    init() {
        LoyaltyManager.shared.start()

        LoyaltyManager.shared.barcodeHandler = { _, _ in
            if Storage.userNumbers.isEmpty {
                return [
                    Barcode(withValue: "Please"),
                    Barcode(withValue: "add"),
                    Barcode(withValue: "Phone number"),
                    Barcode(withValue: "or"),
                    Barcode(withValue: "Loyalty card number")]
                }
            return Storage
                .userNumbers
                .map { Barcode(withValue: $0) }
        }

        LoyaltyManager
            .shared
            .barcodeStatusTransferPublisher
            .receive(on: DispatchQueue.main)
            .sink { status in
                switch status {
                case .failure:
                    self.status = .failure
                case .success:
                    self.status = .success
                @unknown default:
                    fatalError("API was dramatically changed")
                }
                self.dropToDefaultStatus()
            }.store(in: &subscriptions)

    }

    func loadOffers() {
        Task {
            do {
                let newOffers = try await fetchOffers()
                await MainActor.run {
                    self.offers = newOffers
                }

            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }

    private func dropToDefaultStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.status = .waiting
        }
    }

    func fetchOffers() async throws -> [Offer] {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[Offer], Error>) in
            JBRepository.shared.offers.fromCache().then { offers in
                continuation.resume(returning: offers)
            }.catch { error in
                continuation.resume(throwing: error)
            }
        }
    }

    // MARK: - Initialization

}

extension LoyaltyViewModel: LoyaltyViewModelProtocol {

}
