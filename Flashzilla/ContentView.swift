//
//  ContentView.swift
//  Flashzilla
//
//  Created by Milo Wyner on 9/22/21.
//

import SwiftUI

struct ContentView: View {
    @State private var currentAmount: Angle = .degrees(0)
    @State private var finalAmount: Angle = .degrees(0)

    var body: some View {
        Text("Hello, World!")
            .rotationEffect(currentAmount + finalAmount)
            .gesture(
                RotationGesture()
                    .onChanged { angle in
                        self.currentAmount = angle
                    }
                    .onEnded { angle in
                        self.finalAmount += self.currentAmount
                        self.currentAmount = .degrees(0)
                    }
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
