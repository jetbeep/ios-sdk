//
//  LockerView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ClearButton: ViewModifier {
    @Binding var text: String

    public func body(content: Content) -> some View {
        HStack {
            content
            Button(action: {
                self.text = ""
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .opacity(text.isEmpty ? 0 : 1)
            })
            .padding(.trailing, 8)
            .padding(.vertical, 12)
        }
    }
}

private struct RoundedBorderTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(Color.white)
            )
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}


private struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                .background(Color.clear)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            configuration.label
                .frame(height: 44)
                .foregroundColor(.white)

        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .frame(maxWidth: .infinity, maxHeight: 44)
        .cornerRadius(10)
    }
}

private struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.body))
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .padding()
    }
}


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

        VStack(spacing: 16) {
            tokenField
            tokenResult
            searchButton
            applyButton
            stopButton
            nearbyDevices
        }
        .padding(.horizontal)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    // MARK: - Display logic
    var tokenField: some View {
        return TextField("Please input token here:", text: $viewModel.tokenInput)
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            .modifier(ClearButton(text: $viewModel.tokenInput))
            .modifier(RoundedBorderTextFieldModifier())
            .padding(.top, 20)
            .frame(height: 56)

    }


    var tokenResult: some View {
        return TextField("Token result:", text: $viewModel.tokenResult)
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            .modifier(RoundedBorderTextFieldModifier())
            .frame(height: 56)
    }

    var searchButton: some View {
        return Button("Search") {
            viewModel.startSearch()
        }
        .buttonStyle(ActionButtonStyle())
    }

    var applyButton: some View {
        return Button("Apply") {
            viewModel.applyToken()
        }
        .buttonStyle(ActionButtonStyle())
        .disabled(!viewModel.isApplyButtonEnabled)
        .opacity(viewModel.isApplyButtonEnabled ? 1 : 0.5)
    }

    var stopButton: some View {
        return Button("Stop") {
            viewModel.stopSearch()
        }
        .buttonStyle(ActionButtonStyle())
    }

    var nearbyDevices: some View {
        return VStack {
            // Header
            Text("Nearby devices:")
                .font(.title)
                .padding(.top)
            
            List(viewModel.deviceNearby, id: \.self) { device in
                NearbyView(title: device.title,
                           subtitle: device.subtitle,
                           status: device.device.connectionState )
            }.listStyle(.plain)
                .padding(.horizontal)
        }

    }

    
    
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
