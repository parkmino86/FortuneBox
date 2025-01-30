//
//  FortuneBoxWidget.swift
//  FortuneBoxWidget
//
//  Created by minoh.park on 1/27/25.
//

import SwiftUI
import WidgetKit

struct FortuneBoxWidget: Widget {
    let kind: String = "FortuneBoxWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: FortuneBoxIntent.self,
                               provider: FortuneBoxEntryProvider())
        { entry in
            FortuneBoxEntryView(entry: entry)
                .widgetURL(URL(string: "fortunebox://"))
        }
        .configurationDisplayName("오늘의 이모지 확인하기")
        .description("이모지와 함께 오늘의 하루를 가볍게 시작해 보세요! 😊🎉")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
