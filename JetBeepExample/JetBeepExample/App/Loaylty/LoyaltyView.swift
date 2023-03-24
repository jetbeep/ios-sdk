//
//  LoyaltyView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 15.03.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import SwiftUI

protocol LoyaltyViewProtocol {
}

struct LoyaltyView: View {
    // MARK: - Public properties
	@ObservedObject private (set) var viewModel: LoyaltyViewModel
	
    init (_ viewModel: LoyaltyViewModel) {
           self.viewModel = viewModel
       }
    
    // MARK: - Private properties
    
    // MARK: - View lifecycle
    
    var body: some View {
        ScrollView(.vertical) {
            LoyaltyTransferView(status: viewModel.status)
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
    
    // MARK: - Display logic
    
    // MARK: - Actions
    
    // MARK: - Overrides
    
    // MARK: - Private functions
}

struct LoyaltyView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyView(LoyaltyViewModel())
    }
}


extension LoyaltyView: LoyaltyViewProtocol {
}
