//
//  LocationsView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import SwiftUI

protocol LocationsViewProtocol {
}

private struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.headline))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct SubtitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.subheadline))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct LocationsView: View {
    // MARK: - Public properties
	@ObservedObject private (set) var viewModel: LocationsViewModel

    init (_ viewModel: LocationsViewModel) {
           self.viewModel = viewModel
       }

    // MARK: - Private properties

    // MARK: - View lifecycle

    var body: some View {
        ScrollView(.vertical) {
            enteredPart
            exitedPart
            nearbyPart
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
    }

    var enteredPart: some View {
        VStack {
            Text("Shop entered:")
                .modifier(TitleModifier())

            Text(viewModel.enteredShop)
                .modifier(SubtitleModifier())

            Text("Merchant entered:")
                .modifier(TitleModifier())

            Text(viewModel.enteredMerchant)
                .modifier(SubtitleModifier())
        }
        .padding(.top)
    }

    var exitedPart: some View {
        VStack {
            Text("Shop exited:")
                .modifier(TitleModifier())

            Text(viewModel.exitedShop)
                .modifier(SubtitleModifier())

            Text("Merchant exited:")
                .modifier(TitleModifier())

            Text(viewModel.exitedMerchant)
                .modifier(SubtitleModifier())
        }
    }

    var nearbyPart: some View {
        VStack {
            Text("Shops nearby:")
                .modifier(TitleModifier())

            Text(viewModel.nearbyShops)
                .modifier(SubtitleModifier())

            Text("Merchants nearby:")
                .modifier(TitleModifier())

            Text(viewModel.nearbyMerchants)
                .modifier(SubtitleModifier())
        }
    }

    // MARK: - Display logic

    // MARK: - Actions

    // MARK: - Overrides

    // MARK: - Private functions
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView(LocationsViewModel())
    }
}

extension LocationsView: LocationsViewProtocol {
}
