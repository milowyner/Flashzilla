//
//  EditCards.swift
//  Flashzilla
//
//  Created by Milo Wyner on 9/25/21.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cards = ContentView.loadCards() ?? []
    @State private var showingAlert = false
    
    @State private var prompt = ""
    @State private var answer = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach((0..<cards.count).reversed(), id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete { indexSet in
                        cards.remove(atOffsets: indexSet)
                        save()
                    }
                }
                
                HStack {
                    TextField("Prompt", text: $prompt)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Answer", text: $answer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        let card = Card(prompt: prompt, answer: answer)
                        withAnimation {
                            cards.append(card)
                        }
                        prompt = ""
                        answer = ""
                        save()
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)

            }
            .navigationBarTitle(Text("Edit Cards"))
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func save() {
        guard let data = try? JSONEncoder().encode(cards) else { print("Error saving"); return }
        UserDefaults.standard.set(data, forKey: "SavedCards")
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            EditCards()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            EditCards()
        }
    }
}
