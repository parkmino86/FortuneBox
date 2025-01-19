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
                    .font(.title)
                    .foregroundColor(.white)

            case .spinning(let fortune):
                EmojiSpinnerView(viewModel: EmojiSpinnerViewModel(fortune: fortune)) {
                    viewModel.completeSpinning()
                }

            case .completed(let fortune):
                VStack {
                    HStack {
                        ForEach(fortune.emojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: 80))
                        }
                    }
                    Text(fortune.text)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: viewModel.state)
                }
            }

            Spacer()

            Button(action: {
                viewModel.startSpinning()
            }) {
                Text("운세 열어보기")
                    .font(.system(size: 18, weight: .semibold))
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
            .opacity(viewModel.isSpinning ? 0.0 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: viewModel.isSpinning)
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}
