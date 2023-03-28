//
//  AddUserNumberView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.03.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import SwiftUI

struct AddUserNumberView : View {

    @State var text: String = ""

    let onSave: (String) -> Void

    var body: some View {
        VStack {
            textField
            saveButton
        }
    }

    var textField: some View {
        TextField("Enter phone number or card number", text: $text)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
    }
    var saveButton: some View {
        Button("Save") {
            onSave(text)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
    }
}


struct AddUserNumberView_Previews: PreviewProvider {
    struct AddUserNumberViewWrapper: View {

        let onSave: (String) -> Void

        var body: some View {
            AddUserNumberView(onSave: onSave)
        }
    }

    static var previews: some View {
        AddUserNumberViewWrapper(onSave: { value in
            print("New number saved \(value)")
        })
    }
}
