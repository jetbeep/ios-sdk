//
//  AddUserNumbersView.swift
//  Pods
//
//  Created by Max Tymchii on 28.03.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

protocol AddUserNumbersViewProtocol {
}

struct AddUserNumbersView: View {
    // MARK: - Public properties
    @ObservedObject private (set) var viewModel: AddUserNumbersViewModel

    init (_ viewModel: AddUserNumbersViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private properties
    @State private var showAddNumberSheet: Bool = false
    

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if viewModel.userNumbers.count == 0 {
                VStack(alignment: .center, spacing: 20) {
                    Text("Please add any phone or loyalty card number to instantiate personalisation functionality.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .frame(maxHeight: .infinity)
                        .padding(.leading, 28)

                }

            } else {
                scrollView
            }
            HStack {
                Spacer()
                addButton
            }
        }
        .sheet(isPresented: $showAddNumberSheet) {
            AddUserNumberView { number in
                viewModel.add(userNumber: number)
                showAddNumberSheet = false
            }
        }
    }

    var scrollView: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.userNumbers, id: \.self) { number in
                    HStack {
                        Text(number)
                        Spacer()
                        Button(action: {
                            viewModel.remove(userNumber: number)
                        }) {
                            Image(systemName: "minus.circle")
                        }
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1))
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                }
            }
        }
    }


    var addButton: some View {
        Button(action: {
            showAddNumberSheet = true
        }) {
            Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding(.trailing, 20)
                .padding(.bottom, 20)
        }
    }




    // MARK: - Display logic

    // MARK: - Actions

    // MARK: - Overrides

    // MARK: - Private functions
}

struct AddUserNumbersView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserNumbersView(AddUserNumbersViewModel())
    }
}


extension AddUserNumbersView: AddUserNumbersViewProtocol {
}
