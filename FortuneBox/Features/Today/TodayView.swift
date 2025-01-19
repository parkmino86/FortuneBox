//
//  TodayView.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel()

    var body: some View {
        VStack {
            Spacer()

            switch viewModel.state {
            case .appear:
                Text("운세를 열어보세요!")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.white)

            case .emojiSpinnerAnimation(let fortune):
                EmojiSpinnerView(viewModel: EmojiSpinnerViewModel(fortune: fortune)) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        viewModel.emojiSpinnerAnimationCompleted()
                    }
                }

            case .emojiSpinnerAnimationCompleted(let fortune):
                VStack {
                    HStack {
                        ForEach(fortune.emojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: 80))
                        }
                    }
                }
                .onAppear {
                    viewModel.typingTextAnimation()
                }
                
            case .typingTextAnimation(let fortune):
                TypingAnimationView(message: fortune.text) {
                    viewModel.typingTextAnimationCompleted()
                }
                .font(.system(size: 22, weight: .regular))
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .kerning(1.2)
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
            case .typingTextAnimationCompleted(let fortune):
                Text(fortune.text)
                    .font(.system(size: 22, weight: .regular))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .kerning(1.2)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
            }

            Spacer()

            Button(action: {
                viewModel.confirmButtonTapped()
            }) {
                Text("운세 열어보기")
                    .font(.system(size: 18, weight: .medium))
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
            }
            .bluePurpleGradientBackground()
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .disabled(viewModel.isSpinning)
            .opacity(viewModel.isSpinning || viewModel.isTyping ? 0.0 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: viewModel.isCompleted)
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}
