//
//  SpinnerItemViewModel.swift
//  FortuneBox
//
//  Created by minoh.park on 1/19/25.
//

import Foundation
import Combine

class SpinnerItemViewModel: ObservableObject {
    @Published var currentEmoji: String = "🎲"
    @Published var isFinished: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let emojiList: [String]
    private let spinSpeed: Double
    private let spinCount: Int
    private let resultEmoji: String

    init(
        emojiList: [String] = [
            "🚇", "🪑", "📖", "🍽", "🍛", "👀",
            "☕", "🧹", "💦", "💻", "📊", "💾",
            "🏢", "🧍‍♂️", "🙂", "🍻", "🕒", "💼",
            "🍪", "🍩", "👏", "❄️", "🥵", "🧥",
            "🖨", "📄", "🔧", "☔", "🌧", "🌂"
        ],
        spinSpeed: Double,
        spinCount: Int,
        finalEmoji: String
    ) {
        self.emojiList = emojiList
        self.spinSpeed = spinSpeed
        self.spinCount = spinCount
        self.resultEmoji = finalEmoji
    }

    func startSpinning() {
        Timer.publish(every: spinSpeed, on: .main, in: .common)
            .autoconnect()
            .prefix(spinCount)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.currentEmoji = self?.resultEmoji ?? "🎲"
                    self?.isFinished = true
                },
                receiveValue: { [weak self] _ in
                    self?.currentEmoji = self?.emojiList.randomElement() ?? "⁉️"
                }
            )
            .store(in: &cancellables)
    }
}
