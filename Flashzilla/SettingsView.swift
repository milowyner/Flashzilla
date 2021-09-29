//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Milo Wyner on 9/27/21.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var wrongAnswerBackToArray: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Wrong answers go back into the deck", isOn: $wrongAnswerBackToArray)
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }
    }
    
    func dismiss() {
        UserDefaults.standard.set(wrongAnswerBackToArray, forKey: "wrongAnswerBackToArray")
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(wrongAnswerBackToArray: .constant(false))
    }
}
