//
//  AddUserNumbersViewModel.swift
//  Pods
//
//  Created by Max Tymchii on 28.03.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import SwiftUI
import JetBeepFramework

protocol AddUserNumbersViewModelProtocol: AnyObject {
    func syncWithDB()
}

class AddUserNumbersViewModel: ObservableObject {
    // MARK: - Public variables

    // MARK: - Private variables
    var router: AddUserNumbersRouterProtocol!
    @Published var userNumbers = Storage.userNumbers

    // MARK: - Initialization

    func remove(userNumber: String) {
        Storage.deleteNumber(userNumber)
        userNumbers = Storage.userNumbers
        syncWithDB()
    }

    func add(userNumber: String) {
        Storage.addNumber(userNumber)
        userNumbers = Storage.userNumbers
        syncWithDB()
    }

}

extension AddUserNumbersViewModel: AddUserNumbersViewModelProtocol {
    func syncWithDB() {

        JetBeep.shared
            .sync()
            .then { _ in
                print("Success sync")
            }
            .catch { error in
                print("Error sync: \(error)")

            }
    }
}
