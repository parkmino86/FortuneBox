//
//  EmojiSpinnerViewModel.swift
//  FortuneBox
//
//  Created by minoh.park on 1/19/25.
//

import Foundation
import Combine

final class EmojiSpinnerViewModel: ObservableObject {
    @Published var spinnerItems: [SpinnerItemViewModel] = []
    @Published var allSpinnersCompleted: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init(fortune: Fortune) {
        guard fortune.emojis.isEmpty == false else {
            return
        }

        let spinners = [
            (speed: 0.05, count: 20, emoji: fortune.emojis[0 % fortune.emojis.count]),
            (speed: 0.07, count: 30, emoji: fortune.emojis[1 % fortune.emojis.count]),
            (speed: 0.09, count: 40, emoji: fortune.emojis[2 % fortune.emojis.count])
        ]

        self.spinnerItems = spinners.map { config in
            SpinnerItemViewModel(
                spinningSpeed: config.speed,
                spinningCount: config.count,
                finalEmoji: config.emoji
            )
        }

        spinnerItems.forEach { viewModel in
            viewModel.$isCompleted
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else { return }
                    self.allSpinnersCompleted = self.spinnerItems.allSatisfy { $0.isCompleted }
                }
                .store(in: &cancellables)
        }
    }
}
