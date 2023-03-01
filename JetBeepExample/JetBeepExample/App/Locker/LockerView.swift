//
//  LockerView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import SwiftUI

protocol LockerViewProtocol {
}

struct LockerView: View {
    // MARK: - Public properties
	@ObservedObject private (set) var viewModel: LockerViewModel
	
    init (_ viewModel: LockerViewModel) {
           self.viewModel = viewModel
       }
    
    // MARK: - Private properties
    
    // MARK: - View lifecycle
    
    var body: some View {
		EmptyView()
    }
    
    // MARK: - Display logic
    
    // MARK: - Actions
    
    // MARK: - Overrides
    
    // MARK: - Private functions
}

struct LockerView_Previews: PreviewProvider {
    static var previews: some View {
        LockerView(LockerViewModel())
    }
}


extension LockerView: LockerViewProtocol {
}
