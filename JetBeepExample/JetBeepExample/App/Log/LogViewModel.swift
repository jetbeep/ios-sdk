//
//  LogViewModel.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import Foundation
import SwiftUI
import JetBeepFramework
import Combine

protocol LogViewModelProtocol: AnyObject {
}

class LogViewModel: ObservableObject {
    // MARK: - Public variables
    var router: LogRouterProtocol!

    // MARK: - Private variables
    @Published var text: String = ""

    init() {
        
        Log.logCompletion = { [weak self] newText in
            guard let string = newText, let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.text.append("\(string)\n")
            }

        }
    }
    
    // MARK: - Initialization

}

extension LogViewModel: LogViewModelProtocol {
   
}
