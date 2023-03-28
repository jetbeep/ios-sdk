//
//  LoyaltyView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 15.03.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import SwiftUI
import JetBeepFramework

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
        ScrollView(.vertical, showsIndicators: false) {
            LoyaltyTransferView(status: viewModel.status)
                .padding(.top, 20)

            VStack(alignment: .leading) {
                Text("Offers")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .multilineTextAlignment(.leading)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 12, trailing: 20))

                ForEach(viewModel.offers, id: \.self) { offer in
                    OfferView(offer: offer)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .onAppear() {
            viewModel.loadOffers()
        }


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
