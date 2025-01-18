//
//  EmojiSpinnerView.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import SwiftUI

struct EmojiSpinnerView: View {
    @Binding var isSpinning: Bool
    
    let itemsToSelect: [String]

    private let availableItems: [String] = [
        "🚇", "🪑", "📖",
        "🍽", "🍛", "👀",
        "☕", "🧹", "💦",
        "💻", "📊", "💾",
        "🏢", "🧍‍♂️", "🙂",
        "🍻", "🕒", "💼",
        "🍪", "🍩", "👏",
        "❄️", "🥵", "🧥",
        "🖨", "📄", "🔧",
        "☔", "🌧", "🌂"
    ]

    @State private var spinningItems: [String] = ["🎲", "🎲", "🎲"]
    @State private var spinningSpeeds: [Double] = [0.05, 0.07, 0.09]

    let onSpinComplete: () -> Void

    var body: some View {
        HStack {
            ForEach(0..<spinningItems.count, id: \.self) { index in
                Text(spinningItems[index])
                    .font(.system(size: 80))
                    .scaleEffect(isSpinning ? 1.0 : 1.2)
                    .animation(
                        .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5),
                        value: isSpinning
                    )
            }
        }
        .onAppear {
            if isSpinning {
                startSpinning()
            }
        }
    }

    private func startSpinning() {
        for index in 0..<spinningItems.count {
            spinSlot(at: index)
        }
    }

    private func spinSlot(at index: Int) {
        var spinCount = 0

        Timer.scheduledTimer(withTimeInterval: spinningSpeeds[index], repeats: true) { timer in
            guard isSpinning else {
                timer.invalidate()
                return
            }

            spinningItems[index] = availableItems.randomElement() ?? "🎲"
            spinCount += 1

            if spinCount >= calculateSpinThreshold(for: index) {
                timer.invalidate()
                completeSlotSpin(at: index)
            }
        }
    }

    private func completeSlotSpin(at index: Int) {
        spinningItems[index] = itemsToSelect[index]

        if index == spinningItems.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isSpinning = false
                onSpinComplete()
            }
        }
    }

    private func calculateSpinThreshold(for index: Int) -> Int {
        return 20 + index * 10
    }
}
