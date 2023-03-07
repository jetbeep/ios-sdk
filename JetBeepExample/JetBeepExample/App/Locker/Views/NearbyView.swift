//
//  NearbyView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 06.03.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import Foundation
import SwiftUI
import JetBeepFramework

struct NearbyView: View {
    var title: String
    var subtitle: String
    let status: Device.ConnectionState

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            Spacer()
            StatusView(status: status)
        }
    }
}
