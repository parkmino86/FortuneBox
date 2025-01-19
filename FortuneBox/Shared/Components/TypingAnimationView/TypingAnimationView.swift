//
//  TypingAnimationView.swift
//  FortuneBox
//
//  Created by minoh.park on 1/19/25.
//

import SwiftUI

struct TypingAnimationView: View {
    @StateObject private var viewModel = TypingAnimationViewModel()
    let message: String
    let allTypingCompleted: () -> Void

    var body: some View {
        Text(viewModel.displayedText)
            .onAppear {
                viewModel.animate(text: message)
            }
            .onDisappear {
                viewModel.invalidate()
            }
            .onReceive(viewModel.$allTypingCompleted.filter { $0 }) { _ in
                allTypingCompleted()
            }
    }
}
