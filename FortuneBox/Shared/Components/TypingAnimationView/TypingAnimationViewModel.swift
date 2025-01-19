//
//  TypingAnimationViewModel.swift
//  FortuneBox
//
//  Created by minoh.park on 1/19/25.
//

import SwiftUI
import Combine

class TypingAnimationViewModel: ObservableObject {
    @Published var displayedText: String = ""
    @Published var allTypingCompleted: Bool = false

    private var cancellables = Set<AnyCancellable>()

    func animate(text: String, interval: TimeInterval = 0.1) {
        displayedText = ""
        var currentIndex = 0

        Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                guard currentIndex < text.count else {
                    self.invalidate()
                    self.allTypingCompleted = true
                    return
                }

                let index = text.index(text.startIndex, offsetBy: currentIndex)
                self.displayedText.append(text[index])
                currentIndex += 1
            }
            .store(in: &cancellables)
    }

    func invalidate() {
        cancellables.removeAll()
    }
}
