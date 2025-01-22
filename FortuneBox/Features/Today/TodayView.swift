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
                Text("오늘의 코드,\n운명은 당신의 손끝에!\n운세를 확인하세요!")
                    .font(.system(size: 22, weight: .regular))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .kerning(1.2)
                    .foregroundColor(.white)

            case .emojiSpinnerAnimation(let fortune):
                EmojiSpinnerView(viewModel: EmojiSpinnerViewModel(fortune: fortune)) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        viewModel.emojiSpinnerAnimationCompleted()
                    }
                }

            case .emojiSpinnerAnimationCompleted(let fortune):
                VStack(spacing: 20) {
                    HStack {
                        ForEach(fortune.emojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: 64))
                        }
                    }
                    Text("커밋 성공,\n머지 완료! 운빨 100%!")
                        .font(.system(size: 22, weight: .regular))
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .kerning(1.2)
                        .foregroundColor(.white)
                    Button(action: {
                        viewModel.emojiSpinnerAnimation()
                    }) {
                        Text("운세 빌드 실패!\n재시도합니다.")
                            .font(.system(size: 24, weight: .semibold))
                            .lineSpacing(8)
                            .padding()
                            .foregroundColor(.white)
                            .shimmer()
                    }
                }
                
            case .typingTextAnimation(let fortune):
                VStack(spacing: 20) {
                    HStack {
                        ForEach(fortune.emojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: 64))
                        }
                    }
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
                }
                
            case .typingTextAnimationCompleted(let fortune):
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
                        .kerning(1.2)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                }                
            }

            Spacer()

            Button(action: {
                switch viewModel.state {
                case .emojiSpinnerAnimationCompleted:
                    viewModel.typingTextAnimation()
                default:
                    viewModel.emojiSpinnerAnimation()
                }
            }) {
                Text("운세 빌드 성공? 눌러보세요!")
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
    }
}
