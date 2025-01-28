//
//  TypingAnimationView.swift
//  FortuneBox
//
//  Created by minoh.park on 1/19/25.
//

import SwiftUI

struct TypingAnimationView: View {
    @StateObject private var viewModel: TypingAnimationViewModel = TypingAnimationViewModel()
    let message: String
    let allTypingCompleted: () -> Void

    var body: some View {
        Text(viewModel.currentText)
            .onAppear {
                viewModel.startTypingAnimation(for: message)
            }
            .onDisappear {
                viewModel.stopAnimation()
            }
            .onReceive(viewModel.$isTypingCompleted.filter { $0 }) { _ in
                allTypingCompleted()
            }
    }
}
