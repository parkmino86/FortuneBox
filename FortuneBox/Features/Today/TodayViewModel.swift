//
//  TodayViewModel.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import Foundation

final class TodayViewModel: ObservableObject {
    enum State: Equatable {
        case appear
        case emojiSpinnerAnimation(data: Fortune)
        case emojiSpinnerAnimationCompleted(data: Fortune)
        case typingTextAnimation(data: Fortune)
        case typingTextAnimationCompleted(data: Fortune)
    }

    @Published private(set) var state: State = .appear

    var disabled: Bool {
        if case .emojiSpinnerAnimation = state { return true }
        return false
    }
    
    var opacity: Double {
        if case .emojiSpinnerAnimation = state { return 0.0 }
        if case .typingTextAnimation = state { return 0.0 }
        return 1.0
    }
    
    func emojiSpinnerAnimation() {
        guard disabled == false else { return }
        let fortune = FortuneStorage.shared.fetchRandomFortune() ?? Fortune(
            id: UUID().uuidString,
            text: "오늘은 평범한 하루입니다.",
            emojis: ["🎲", "🎲", "🎲"]
        )
        state = .emojiSpinnerAnimation(data: fortune)
    }

    func emojiSpinnerAnimationCompleted() {
        if case .emojiSpinnerAnimation(let fortune) = state {
            state = .emojiSpinnerAnimationCompleted(data: fortune)
        }
    }
    
    func typingTextAnimation() {
        if case .emojiSpinnerAnimationCompleted(let fortune) = state {
            state = .typingTextAnimation(data: fortune)
        }
    }
    
    func typingTextAnimationCompleted() {
        if case .typingTextAnimation(let fortune) = state {
            state = .typingTextAnimationCompleted(data: fortune)
        }
    }
}
