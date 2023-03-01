//
//  LockerViewModel.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import Foundation
import SwiftUI

protocol LockerViewModelProtocol: AnyObject {

}

class LockerViewModel: ObservableObject {
    // MARK: - Public variables
 

    // MARK: - Private variables
    var router: LockerRouterProtocol!
    
    // MARK: - Initialization

}

extension LockerViewModel: LockerViewModelProtocol {
   
}
