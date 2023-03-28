//
//  Storage.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.03.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import Foundation
import JetBeepFramework

class Storage {
    private static let userDefaults = UserDefaults.standard
    private static let userNumbersKey = "userNumbers"

    static var userNumbers: [String] {
        return userDefaults.stringArray(forKey: userNumbersKey) ?? []
    }

    static func addNumber(_ number: String) {
        var numbers = userNumbers
        numbers.append(number)
        updateStoredNumbers(numbers)
    }

    static func deleteNumber(_ number: String) {
        var numbers = userNumbers
        if let index = numbers.firstIndex(of: number) {
            numbers.remove(at: index)
            updateStoredNumbers(numbers)
        }
    }

    static func deleteAllNumbers() {
        userDefaults.removeObject(forKey: userNumbersKey)
    }

    static func addNumbers(_ newNumbers: [String]) {
        var numbers = userNumbers
        numbers.append(contentsOf: newNumbers)
        updateStoredNumbers(numbers)
    }

    private static func updateStoredNumbers(_ numbers: [String]) {
        JetBeep.shared.userNumbers = numbers
        userDefaults.set(numbers, forKey: userNumbersKey)
    }
}
