//
//  TodayViewModel.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import Foundation

final class TodayViewModel: ObservableObject {
    @Published var todayFortune: Fortune?
    @Published var isSpinning = false
    @Published var showResult = false

    func openFortune() {
        if let randomFortune = FortuneStorage.shared.fetchRandomFortune() {
            todayFortune = randomFortune
        } else {
            print("⚠️ Failed to fetch a random fortune. Using default fortune.")
            todayFortune = Fortune(
                id: UUID().uuidString,
                text: "오늘은 평범한 하루입니다.",
                emojis: ["🎲"]
            )
        }
    }
}
