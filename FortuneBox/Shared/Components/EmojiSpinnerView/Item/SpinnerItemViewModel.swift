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
    @Published var isCompleted: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let availableEmoji: [String]
    private let spinningSpeed: Double
    private let spinningCount: Int
    private let finalEmoji: String

    init(
        availableEmoji: [String] = [
            "🚇", "🪑", "📖", "🍽", "🍛", "👀",
            "☕", "🧹", "💦", "💻", "📊", "💾",
            "🏢", "🧍‍♂️", "🙂", "🍻", "🕒", "💼",
            "🍪", "🍩", "👏", "❄️", "🥵", "🧥",
            "🖨", "📄", "🔧", "☔", "🌧", "🌂"
        ],
        spinningSpeed: Double,
        spinningCount: Int,
        finalEmoji: String
    ) {
        self.availableEmoji = availableEmoji
        self.spinningSpeed = spinningSpeed
        self.spinningCount = spinningCount
        self.finalEmoji = finalEmoji
    }

    func startSpinning() {
        Timer.publish(every: spinningSpeed, on: .main, in: .common)
            .autoconnect()
            .prefix(spinningCount)
            .sink(
                receiveCompletion: { [weak self] _ in
                    guard let self else { return }
                    self.currentEmoji = self.finalEmoji
                    self.isCompleted = true
                },
                receiveValue: { [weak self] _ in
                    guard let self else { return }
                    self.currentEmoji = self.availableEmoji.randomElement() ?? "⁉️"
                }
            )
            .store(in: &cancellables)
    }
}
