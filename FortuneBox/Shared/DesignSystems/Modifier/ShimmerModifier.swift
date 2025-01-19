//
//  ShimmerModifier.swift
//  FortuneBox
//
//  Created by minoh.park on 1/19/25.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var gradientLocation: CGFloat = -1.0

    private let duration: Double
    private let gradientColors: [Color]

    init(duration: Double = 2.0, gradientColors: [Color] = [Color.clear, Color.blue.opacity(0.7), Color.purple.opacity(0.7), Color.clear]) {
        self.duration = duration
        self.gradientColors = gradientColors
    }

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .offset(x: gradientLocation * geometry.size.width)
                    .mask(content)
                )
                .onAppear {
                    withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
                        gradientLocation = 2.0
                    }
                }
                .onDisappear {
                    gradientLocation = -1.0
                }
        }
    }
}

extension View {
    func shimmer(duration: Double = 2.0, gradientColors: [Color] = [Color.clear, Color.blue.opacity(0.7), Color.purple.opacity(0.7), Color.clear]) -> some View {
        self.modifier(ShimmerModifier(duration: duration, gradientColors: gradientColors))
    }
}
