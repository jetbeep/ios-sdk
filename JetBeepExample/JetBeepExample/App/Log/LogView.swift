//
//  LogView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.02.2023.
//  Copyright (c) 2023 Max Tymchii. All rights reserved.
//

import SwiftUI

protocol LogViewProtocol {
}

struct LogView: View {
    // MARK: - Public properties
	@ObservedObject private (set) var viewModel: LogViewModel

    init (_ viewModel: LogViewModel) {
           self.viewModel = viewModel
       }

    // MARK: - Private properties

    // MARK: - View lifecycle

    var body: some View {
        ScrollView(.vertical) {
            Text(viewModel.text)
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = viewModel.text
                    } label: {
                        Text("Copy to clipboard")
                        Image(systemName: "doc.on.doc")
                    }
                }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

    }

    // MARK: - Display logic

    // MARK: - Actions

    // MARK: - Overrides

    // MARK: - Private functions
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(LogViewModel())
    }
}

extension LogView: LogViewProtocol {
}
