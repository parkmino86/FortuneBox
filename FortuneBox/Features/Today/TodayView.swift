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
            case .idle:
                Text("운세를 열어보세요!")
                    .font(.title)

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
                        .padding(.top, 20)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: viewModel.state)
                }
            }

            Spacer()

            Button(action: {
                viewModel.startSpinning()
            }) {
                Text("확인")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isSpinning ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .disabled(viewModel.isSpinning)
            .opacity(viewModel.isSpinning ? 0.0 : 1.0)
        }
        .padding()
    }
}
