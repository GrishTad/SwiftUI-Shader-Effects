//
//  CircleLoaderEffectView.swift
//  ShaderEffects
//
//  Created by Grisha Tadevosyan on 16.11.24.
//

import SwiftUI

struct CircleLoaderEffectView: View {
    @State var color: Color
    let startDate = Date()
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { _ in
                VStack {
                    color
                }
                .colorEffect(
                    ShaderLibrary.CircleLoaderEffect(
                        .float2(geometry.size),
                        .float(-startDate.timeIntervalSinceNow)
                    )
                )
            }
        }
    }
}

#Preview {
    CircleLoaderEffectView(color: Color.blue)
        .frame(width: 200, height: 200)
}
