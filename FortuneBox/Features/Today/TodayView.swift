//
//  TodayView.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: TodayViewModel

    init(viewModel: TodayViewModel = TodayViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Spacer()

            if let fortune = viewModel.state.fortune {
                switch viewModel.state.viewState {
                case .emojiSpinnerAnimation:
                    EmojiSpinnerView(viewModel: EmojiSpinnerViewModel(fortune: fortune)) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            viewModel.send(.completeEmojiSpinnerAnimation)
                        }
                    }

                case .emojiSpinnerAnimationCompleted:
                    VStack(spacing: 20) {
                        HStack {
                            ForEach(fortune.emojis, id: \.self) { emoji in
                                Text(emoji)
                                    .font(.system(size: 64))
                            }
                        }
                        Text("이모지가 정해졌어요!\n어떤 하루일까요?!")
                            .lineLimit(nil)
                            .font(.system(size: 22, weight: .regular))
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .foregroundColor(.white)
                    }

                case .typingTextAnimation:
                    VStack(spacing: 20) {
                        HStack {
                            ForEach(fortune.emojis, id: \.self) { emoji in
                                Text(emoji)
                                    .font(.system(size: 64))
                            }
                        }
                        TypingAnimationView(message: fortune.text) {
                            viewModel.send(.completeTypingTextAnimation)
                        }
                        .font(.system(size: 22, weight: .regular))
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    }

                case .typingTextAnimationCompleted:
                    VStack(spacing: 20) {
                        HStack {
                            ForEach(fortune.emojis, id: \.self) { emoji in
                                Text(emoji)
                                    .font(.system(size: 64))
                            }
                        }
                        Text(fortune.text)
                            .font(.system(size: 22, weight: .regular))
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                    }

                default:
                    Text("오늘은 어떤 하루가 될까요?")
                        .font(.system(size: 22, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            } else {
                Text("오늘은 어떤 하루가 될까요?")
                    .font(.system(size: 22, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: {
                switch viewModel.state.viewState {
                case .emojiSpinnerAnimationCompleted:
                    viewModel.send(.startTypingTextAnimation)
                default:
                    viewModel.send(.startEmojiSpinnerAnimation)
                }
            }) {
                Text(viewModel.buttonTitle)
                    .font(.system(size: 18, weight: .medium))
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .shimmer(gradientColors: [Color.clear,
                                              Color.clear,
                                              Color.black.opacity(1.0),
                                              Color.clear,
                                              Color.clear,
                                              Color.clear,
                                              Color.clear])
            }
            .bluePurpleGradientBackground()
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .disabled(viewModel.disabled)
            .opacity(viewModel.opacity)
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .onReceive(NotificationCenter.default.publisher(for: .didFortuneBoxWidgetTapped)) { _ in
            viewModel.send(.widgetTapped)
        }
    }
}
