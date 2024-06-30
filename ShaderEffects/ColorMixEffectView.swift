//
//  ContentView.swift
//  ShaderEffects
//
//  Created by Grisha Tadevosyan on 18.06.24.
//

import SwiftUI

struct ColorMixEffectView: View {
    let startDate = Date()
    var body: some View {
        VStack{
          
            
            
            TimelineView(.animation) { context in
                
                Image(systemName: "infinity.circle")
                    .font(.system(size: 300))
                    .glowing(color: .white, blurRadius: 8, glowOpacity: 1)
                    .colorEffect(ShaderLibrary.ColorMixEffect(.float(startDate.timeIntervalSinceNow)))
              
 
                Text("Grish\nTad")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 150))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .colorEffect(ShaderLibrary.ColorMixEffect(.float(startDate.timeIntervalSinceNow)))
            }
        }
    }
}

#Preview {
    ColorMixEffectView()
}
