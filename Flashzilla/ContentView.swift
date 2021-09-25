//
//  ContentView.swift
//  Flashzilla
//
//  Created by Milo Wyner on 9/22/21.
//

import SwiftUI

struct ContentView: View {
    @State private var cards = [Card](repeating: Card.example, count: 7)
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ForEach(0..<cards.count) { index in
                CardView(card: cards[index])
                    .stacked(at: index, in: cards.count)
            }
        }
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position - 1)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
