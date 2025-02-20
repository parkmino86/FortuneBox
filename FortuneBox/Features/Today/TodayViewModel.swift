//
//  TodayViewModel.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import Foundation
import WidgetKit

final class TodayViewModel: ObservableObject {
    
    struct State: Equatable {
        var fortune: Fortune? = nil
        var viewState: ViewState = .appear
    }

    enum ViewState: Equatable {
        case appear
        case emojiSpinnerAnimation
        case emojiSpinnerAnimationCompleted
        case typingTextAnimation
        case typingTextAnimationCompleted
    }

    enum Action: Equatable {
        case appear
        case startEmojiSpinnerAnimation
        case completeEmojiSpinnerAnimation
        case startTypingTextAnimation
        case completeTypingTextAnimation
        case widgetTapped
    }

    @Published private(set) var state: State

    init(state: State = State()) {
        self.state = state
    }

    func send(_ action: Action) {
        switch action {
        case .appear:
            state = State()

        case .startEmojiSpinnerAnimation:
            guard state.viewState == .appear ||
                    state.viewState == .emojiSpinnerAnimationCompleted ||
                    state.viewState == .typingTextAnimationCompleted else { return }
            Task {
                if let fortune = FortuneStorage.shared.fetchRandomFortune() {
                    DispatchQueue.main.async {
                        self.state.fortune = fortune
                        self.state.viewState = .emojiSpinnerAnimation
                    }
                } else {
                    let defaultFortune = Fortune(
                        id: UUID().uuidString,
                        text: "이모지를 가져오지 못했어요!",
                        emojis: ["⁉️", "⁉️", "⁉️"]
                    )
                    DispatchQueue.main.async {
                        self.state.fortune = defaultFortune
                        self.state.viewState = .emojiSpinnerAnimation
                    }
                }
            }

        case .completeEmojiSpinnerAnimation:
            if state.viewState == .emojiSpinnerAnimation {
                state.viewState = .emojiSpinnerAnimationCompleted
            }

        case .startTypingTextAnimation:
            guard state.viewState == .emojiSpinnerAnimationCompleted, let fortune = state.fortune else { return }
            UserDefaultsManager.shared.fortune = fortune
            state.viewState = .typingTextAnimation
            WidgetCenter.shared.reloadAllTimelines()

        case .completeTypingTextAnimation:
            if state.viewState == .typingTextAnimation {
                state.viewState = .typingTextAnimationCompleted
            }

        case .widgetTapped:
            if let fortune = UserDefaultsManager.shared.fortune {
                state.fortune = fortune
                state.viewState = .typingTextAnimationCompleted
            } else {
                state = State()
            }
        }
    }
}

extension TodayViewModel {
    
    var disabled: Bool {
        state.viewState == .emojiSpinnerAnimation
    }

    var opacity: Double {
        state.viewState == .emojiSpinnerAnimation || state.viewState == .typingTextAnimation ? 0.0 : 1.0
    }

    var buttonTitle: String {
        switch state.viewState {
        case .appear:
            return "오늘의 이모지 받기"
        case .emojiSpinnerAnimation:
            return "이모지 가져오는 중..."
        case .emojiSpinnerAnimationCompleted:
            return "이모지의 의미 알아보기"
        case .typingTextAnimation:
            return "메시지 확인 중..."
        case .typingTextAnimationCompleted:
            return "다시 이모지를 뽑아볼까요?"
        }
    }
}
