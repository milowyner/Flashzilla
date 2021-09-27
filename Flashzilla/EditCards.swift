//
//  EditCards.swift
//  Flashzilla
//
//  Created by Milo Wyner on 9/25/21.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cards = [Card]()
    @State private var showingAlert = false
    
    @State private var prompt = ""
    @State private var answer = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Prompt", text: $prompt)
                    TextField("Answer", text: $answer)
                    Button("Add card", action: addCard)
                }
                
                Section {
                    ForEach((0..<cards.count), id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationBarTitle("Edit Cards")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
//            .listStyle(GroupedListStyle())
            .onAppear(perform: loadData)
        }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func save() {
        guard let data = try? JSONEncoder().encode(cards) else { print("Error saving"); return }
        UserDefaults.standard.set(data, forKey: "SavedCards")
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "SavedCards"),
           let decoded = try? JSONDecoder().decode([Card].self, from: data) {
            cards = decoded
        } else {
            print("Error loading")
        }
    }
    
    func addCard() {
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespaces)
        guard !trimmedPrompt.isEmpty && !trimmedAnswer.isEmpty else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        withAnimation {
            cards.insert(card, at: 0)
        }
        prompt = ""
        answer = ""
        save()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func removeCards(atOffsets offsets: IndexSet) {
           cards.remove(atOffsets: offsets)
           save()
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
