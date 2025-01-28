//
//  FortuneBoxEntryView.swift
//  FortuneBox
//
//  Created by minoh.park on 1/27/25.
//

import SwiftUI
import WidgetKit

struct FortuneBoxEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: FortuneBoxEntryProvider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        default:
            EmptyView()
        }
    }
}

extension FortuneBoxEntryView {
    var smallWidget: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(entry.date.dayOfWeekString)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            
            if let emojis = entry.fortune?.emojis, !emojis.isEmpty {
                Text("오늘의 운세는")
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack(spacing: 4) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.title)
                    }
                }
                
                Text("입니다.")
                    .font(.headline)
                    .fontWeight(.bold)
                
            } else {
                Text("오늘의 운세를")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("확인하세요!")
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .containerBackground(.clear, for: .widget)
    }
}

extension FortuneBoxEntryView {
    var mediumWidget: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(entry.date.dayOfWeekString)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            
            if let fortune = entry.fortune, !fortune.emojis.isEmpty {
                Text(fortune.text.replacingOccurrences(of: "\n", with: " "))
                    .font(.subheadline)
                    .kerning(1.2)
                    .foregroundColor(.white)
                    .lineLimit(nil)
                
            } else {
                Text("오늘의 운세를")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("확인하세요!")
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .containerBackground(.clear, for: .widget)
    }
}
