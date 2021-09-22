//
//  ContentView.swift
//  Flashzilla
//
//  Created by Milo Wyner on 9/22/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Success")
                .padding()
                .onTapGesture(perform: simpleSuccess)
            Text("Warning")
                .padding()
                .onTapGesture(perform: simpleWarning)
            Text("Error")
                .padding()
                .onTapGesture(perform: simpleError)
        }
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func simpleError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func simpleWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
