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
        Task {
            do {
                let random = FortuneStorage.shared.fetchRandomFortune()!
                let score = Int.random(in: 0...100)
                let prompt = "\(random.text). 이모티콘 남발. 한국인을 위한 0점은 비관적, 100점은 건설적인 \(score)점 설날 명절 버전. 마지막에 '올해의 운세 점수는 n점!' 표기. 100자 이내."
                let generatedMessage = try await GeminiService.shared.generateContent(with: prompt)
                let fortune = Fortune(
                    id: UUID().uuidString,
                    text: "\(wrapText(generatedMessage, maxLineLength: 16))",
                    emojis: random.emojis
                )
                await MainActor.run {
                    state = .emojiSpinnerAnimation(data: fortune)
                }
                
            } catch {
                if let fortune = FortuneStorage.shared.fetchRandomFortune() {
                    state = .emojiSpinnerAnimation(data: fortune)
                } else {
                    let fortune = Fortune(
                        id: UUID().uuidString,
                        text: "운세를 가져오지 못했어요!",
                        emojis: ["⁉️", "⁉️", "⁉️"]
                    )
                    state = .emojiSpinnerAnimation(data: fortune)
                }
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
            state = .typingTextAnimation(data: fortune)
        }
    }
    
    func typingTextAnimationCompleted() {
        if case .typingTextAnimation(let fortune) = state {
            state = .typingTextAnimationCompleted(data: fortune)
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
