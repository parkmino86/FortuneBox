//
//  FortuneBoxEntryProvider.swift
//  FortuneBox
//
//  Created by minoh.park on 1/27/25.
//

import SwiftUI
import WidgetKit

struct FortuneBoxEntryProvider: AppIntentTimelineProvider {
    func placeholder(in _: Context) -> FortuneBoxEntry {
        FortuneBoxEntry(date: Date(), fortune: UserDefaultsManager.shared.fortune)
    }

    func snapshot(for _: FortuneBoxIntent, in _: Context) async -> FortuneBoxEntry {
        FortuneBoxEntry(date: Date(), fortune: UserDefaultsManager.shared.fortune)
    }

    func timeline(for _: FortuneBoxIntent, in _: Context) async -> Timeline<FortuneBoxEntry> {
        let currentDate = Date()
        let nextDate = Calendar.current.nextDate(after: currentDate, matching: DateComponents(hour: 0), matchingPolicy: .nextTime)!

        let entries = [
            FortuneBoxEntry(date: Date(), fortune: UserDefaultsManager.shared.fortune),
            FortuneBoxEntry(date: nextDate, fortune: nil)
        ]
        return Timeline(entries: entries, policy: .never)
    }
}
