//
//  TodayViewModel.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import Foundation

final class TodayViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case spinning(fortune: Fortune)
        case completed(fortune: Fortune)
    }

    @Published private(set) var state: State = .idle

    var isSpinning: Bool {
        if case .spinning = state { return true }
        return false
    }

    func startSpinning() {
        guard isSpinning == false else { return }
        let fortune = FortuneStorage.shared.fetchRandomFortune() ?? Fortune(
            id: UUID().uuidString,
            text: "오늘은 평범한 하루입니다.",
            emojis: ["🎲", "🎲", "🎲"]
        )
        state = .spinning(fortune: fortune)
    }

    func completeSpinning() {
        if case .spinning(let fortune) = state {
            state = .completed(fortune: fortune)
        }
    }
}
