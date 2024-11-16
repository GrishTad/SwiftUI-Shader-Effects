//
//  ContentView.swift
//  ShaderEffects
//
//  Created by Grisha Tadevosyan on 30.06.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                List {
                    NavigationLink(destination: InfiniteLoopLoader(color: Color.blue)) {
                        Text("Infinite Loop Loader")
                    }
                    NavigationLink(destination: ColorMixEffectView()) {
                        Text("Color Mix Effect View")
                    } 
                    NavigationLink(destination: CircleLoaderEffectView(color: Color.white)) {
                        Text("Circle Loader Effect View")
                    }
                }
                .navigationBarTitle("Effects", displayMode: .inline)
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
        }
    }
}

#Preview {
    ContentView()
}
