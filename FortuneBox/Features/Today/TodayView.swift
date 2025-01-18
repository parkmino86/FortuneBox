//
//  TodayView.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel()
    @State private var isSpinning = false
    @State private var showResult = false

    var body: some View {
        VStack {
            Spacer()

            VStack {
                if isSpinning {
                    EmojiSpinnerView(
                        isSpinning: $isSpinning,
                        itemsToSelect: viewModel.todayFortune?.emojis ?? ["🎲", "🎲", "🎲"]
                    ) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showResult = true
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

            if showResult, let fortune = viewModel.todayFortune {
                Text(fortune.text)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: showResult)
            }

            Spacer()

            Button(action: {
                isSpinning = true
                showResult = false
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
            .disabled(isSpinning)
        }
        .padding()
    }
}
