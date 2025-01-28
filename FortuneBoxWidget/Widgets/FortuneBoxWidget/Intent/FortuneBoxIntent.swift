//
//  FortuneBoxIntent.swift
//  FortuneBox
//
//  Created by minoh.park on 1/27/25.
//

import AppIntents

struct FortuneBoxIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "오늘의 운빨 확인하기"
    static var description = IntentDescription("이모지와 함께 오늘의 운세를 확인하고, 행운을 경험해 보세요!")

    func perform() async throws -> some IntentResult {
        return .result()
    }
}
