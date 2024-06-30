//
//  ContentView.swift
//  ShaderEffects
//
//  Created by Grisha Tadevosyan on 30.06.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: InfiniteLoopLoader(color:Color.blue)) {
                    Text("Infinite Loop Loader")
                }
                NavigationLink(destination: ColorMixEffectView()) {
                    Text("Color Mix Effect View")
                }
            }
            .navigationTitle("Effects")
        }
    }
}

#Preview {
    ContentView()
}
