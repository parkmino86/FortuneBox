//
//  TodayViewModel.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import Foundation
import WidgetKit

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
        Task {
            if let fortune = FortuneStorage.shared.fetchRandomFortune() {
                state = .emojiSpinnerAnimation(data: fortune)
            } else {
                let fortune = Fortune(
                    id: UUID().uuidString,
                    text: "이모지를 가져오지 못했어요!",
                    emojis: ["⁉️", "⁉️", "⁉️"]
                )
                state = .emojiSpinnerAnimation(data: fortune)
            }
        }
    }

    func emojiSpinnerAnimationCompleted() {
        if case .emojiSpinnerAnimation(let fortune) = state {
            state = .emojiSpinnerAnimationCompleted(data: fortune)
        }
    }
    
    func typingTextAnimation() {
        if case .emojiSpinnerAnimationCompleted(let fortune) = state {
            UserDefaultsManager.shared.fortune = fortune
            state = .typingTextAnimation(data: fortune)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func typingTextAnimationCompleted() {
        if case .typingTextAnimation(let fortune) = state {
            state = .typingTextAnimationCompleted(data: fortune)
        }
    }
    
    func didFortuneBoxWidgetTapped() {
        if let fortune = UserDefaultsManager.shared.fortune {
           state = .typingTextAnimationCompleted(data: fortune)
           
       } else {
           state = .appear
       }
    }
}

extension TodayViewModel {
    private func wrapText(_ text: String, maxLineLength: Int) -> String {
        var result = ""
        var currentLine = ""
        
        let cleanedText = text.replacingOccurrences(of: "\n", with: " ")
        let words = cleanedText.split(separator: " ")
        
        for word in words {
            if currentLine.count + word.count + 1 > maxLineLength {
                result += currentLine + "\n"
                currentLine = String(word)
            } else {
                if !currentLine.isEmpty {
                    currentLine += " "
                }
                currentLine += word
            }
        }
        
        if !currentLine.isEmpty {
            result += currentLine
        }
        
        return result
    }
}
