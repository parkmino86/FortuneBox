//
//  TypingAnimationViewModel.swift
//  FortuneBox
//
//  Created by minoh.park on 1/19/25.
//

import SwiftUI
import Combine

class TypingAnimationViewModel: ObservableObject {
    @Published var currentText: String = ""
    @Published var isTypingCompleted: Bool = false

    private var cancellables = Set<AnyCancellable>()

    func startTypingAnimation(for text: String, interval: TimeInterval = 0.1) {
        currentText = ""
        var typingIndex = 0

        Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                guard typingIndex < text.count else {
                    self.stopAnimation()
                    self.isTypingCompleted = true
                    return
                }

                let index = text.index(text.startIndex, offsetBy: typingIndex)
                self.currentText.append(text[index])
                typingIndex += 1
            }
            .store(in: &cancellables)
    }

    func stopAnimation() {
        cancellables.removeAll()
    }
}
