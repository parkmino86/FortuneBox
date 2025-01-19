//
//  GradientBackgroundModifier.swift
//  FortuneBox
//
//  Created by minoh.park on 1/19/25.
//

import SwiftUI

struct GradientBackgroundModifier: ViewModifier {
    var colors: [Color]
    var startPoint: UnitPoint
    var endPoint: UnitPoint

    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
            )
    }
}

extension View {
    private func gradientBackground(colors: [Color], startPoint: UnitPoint = .leading, endPoint: UnitPoint = .trailing) -> some View {
        modifier(GradientBackgroundModifier(colors: colors, startPoint: startPoint, endPoint: endPoint))
    }
}

extension View {
    func bluePurpleGradientBackground(startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> some View {
        gradientBackground(colors: [Color.blue, Color.purple], startPoint: startPoint, endPoint: endPoint)
    }
}
