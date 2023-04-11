//
//  Data+extension.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 10.04.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import Foundation
typealias JSONDictionary = [String: Any]

extension Data {
    var json: JSONDictionary? {
        guard let JSONObject = try? JSONSerialization.jsonObject(with: self, options: []),
                let json = JSONObject as? JSONDictionary else {
            return nil
        }
        return json
    }
}
