//
//  FortuneBoxApp.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import SwiftUI
import AppIntents

@main
struct FortuneBoxApp: App {
    var body: some Scene {
        WindowGroup {
            TodayView()
                .onOpenURL { url in
                    NotificationCenter.default.post(
                        name: .didFortuneBoxWidgetTapped,
                        object: nil,
                        userInfo: nil
                    )
                }
        }
    }
}
