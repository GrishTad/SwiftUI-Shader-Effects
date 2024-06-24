//
//  Utils.swift
//  ShaderEffects
//
//  Created by Grisha Tadevosyan on 24.06.24.
//
import SwiftUI
struct GlowingText: ViewModifier {
    var color: Color = .red
    var blurRadius: CGFloat = 1
    var glowOpacity: Double = 0.8

    func body(content: Content) -> some View {
        content
            .overlay(
                content
                    .shadow(color: color.opacity(glowOpacity), radius: blurRadius)
            )
            .overlay(
                content
                    .shadow(color: color.opacity(glowOpacity / 2), radius: blurRadius / 2)
            )
            .overlay(
                content
                    .shadow(color: color.opacity(glowOpacity / 4), radius: blurRadius / 4)
            )
    }
}

extension View {
    func glowing(color: Color = .red, blurRadius: CGFloat = 10, glowOpacity: Double = 0.8) -> some View {
        self.modifier(GlowingText(color: color, blurRadius: blurRadius, glowOpacity: glowOpacity))
    }
}
