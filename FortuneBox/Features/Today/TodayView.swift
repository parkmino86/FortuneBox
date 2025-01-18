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

            VStack {
                if viewModel.isSpinning {
                    EmojiSpinnerView(
                        isSpinning: $viewModel.isSpinning,
                        itemsToSelect: viewModel.todayFortune?.emojis ?? ["🎲", "🎲", "🎲"]
                    ) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            viewModel.showResult = true
                        }
                    }
                } else {
                    HStack {
                        ForEach(viewModel.todayFortune?.emojis ?? ["🎲", "🎲", "🎲"], id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: 80))
                        }
                    }
                    .padding()
                }
            }

            if viewModel.showResult, let fortune = viewModel.todayFortune {
                Text(fortune.text)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: viewModel.showResult)
            }

            Spacer()

            Button(action: {
                viewModel.isSpinning = true
                viewModel.showResult = false
                viewModel.openFortune()
            }) {
                Text("운빨 열기")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .disabled(viewModel.isSpinning)
        }
        .padding()
    }
}
