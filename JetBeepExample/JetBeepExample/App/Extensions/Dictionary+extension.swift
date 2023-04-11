//
//  Dictionary+extension.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 10.04.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    func toJSONData() throws -> Data {
        guard JSONSerialization.isValidJSONObject(self) else {
            throw NSError(domain: "InvalidJSONObject", code: 0, userInfo: nil)
        }
        return try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys])
    }
}
