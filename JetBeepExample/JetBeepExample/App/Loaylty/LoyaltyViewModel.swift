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
    
    private var subscriptions = Set<AnyCancellable>()
    var router: LoyaltyRouterProtocol!
    
    init() {
        LoyaltyManager.shared.start()
        
        LoyaltyManager.shared.barcodeHandler = { shop, merchant in
            return [Barcode(withValue: "123456789"), Barcode(withValue: "789102335"), Barcode(withValue: "111111111111")]
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
    
    private func dropToDefaultStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.status = .waiting
        }
    }
    // MARK: - Initialization
    
}

extension LoyaltyViewModel: LoyaltyViewModelProtocol {
    
}
