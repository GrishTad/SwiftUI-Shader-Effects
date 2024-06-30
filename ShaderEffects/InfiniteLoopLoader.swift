//
//  ContentView.swift
//  ShaderEffects
//
//  Created by Grisha Tadevosyan on 30.06.24.
//

import SwiftUI

struct InfiniteLoopLoader: View {
    @State var color: Color
    let startDate = Date()
    var body: some View {
        GeometryReader { geometry in
           
                
                TimelineView(.animation) { context in
                    
                    VStack
                    {
                        color
                        
                        
                    }
                    .colorEffect(ShaderLibrary.InfiniteLoaderEffect(
                        .float2(geometry.size),
                        .float(startDate.timeIntervalSinceNow)))
                    
                    
                
            }
        }
    }
}

#Preview {
    InfiniteLoopLoader(color:Color.blue).frame(width:100)
}
