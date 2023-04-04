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

    init (_ viewModel: VendingViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private properties
    
    // MARK: - View lifecycle
    
    var body: some View {

        if viewModel.vendingMachines.count == 0 {
            VStack(alignment: .center) {
                Text("Please get in at vending machine working area")
            }
        } else {
            ScrollView {
                ForEach(viewModel.vendingMachines, id: \.deviceId) { machine in
                    let status = viewModel.status(for: machine)
                    VendingMachineView(title: machine.shop.name, status: status) {
                        print("Tap on machine \(machine) with \(status)")
                        self.viewModel.connect(to: machine)
                    }
                }
                .padding()
            }
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
