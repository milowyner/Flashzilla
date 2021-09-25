//
//  ContentView.swift
//  Flashzilla
//
//  Created by Milo Wyner on 9/22/21.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                print("Moving to the background!")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                print("Moving back to the foreground!")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
                print("User took a screenshot!")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
