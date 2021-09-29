//
//  ContentView.swift
//  Flashzilla
//
//  Created by Milo Wyner on 9/22/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    @State private var cards = [Card]()
    
    @State private var isActive = true
    @State private var timeRemaining = 100
    let timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .common).autoconnect()
    
    @State private var showingEditScreen = false
    @State private var showingSettingsScreen = false
    @State private var showingAlert = false
    
    @State private var wrongAnswerBackToArray = false
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.75)
                    )
                
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) { answer in
                            removeCard(at: index, correct: answer)
                        }
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibility(hidden: index < cards.count - 1)
                        .stacked(at: index, in: cards.count)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        showingSettingsScreen = true
                    }) {
                        Image(systemName: "gearshape")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    Spacer()

                    Button(action: {
                        showingEditScreen = true
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if (differentiateWithoutColor || accessibilityEnabled) && !cards.isEmpty {
                VStack {
                    Spacer()

                    HStack {
                        Button(action: {
                            removeCard(at: cards.count - 1, correct: false)
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()
                        
                        Button(action: {
                            removeCard(at: cards.count - 1, correct: true)
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onAppear(perform: {
            wrongAnswerBackToArray = UserDefaults.standard.bool(forKey: "wrongAnswerBackToArray")
            if loadData() == false {
                isActive = false
                showingEditScreen = true
            }
        })
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCards()
        }
        .sheet(isPresented: $showingSettingsScreen) {
            SettingsView(wrongAnswerBackToArray: $wrongAnswerBackToArray)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Time's up!"), dismissButton: .default(Text("Start Over"), action: {
                resetCards()
            }))
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                showingAlert = true
                isActive = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if !cards.isEmpty {
                isActive = true
            }
        }
    }
    
    func removeCard(at index: Int, correct: Bool) {
        guard index >= 0 else { return }
        let card = cards.remove(at: index)
        
        if !correct && wrongAnswerBackToArray {
            cards.insert(card, at: 0)
        }
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        loadData()
        timeRemaining = 100
        isActive = true
    }
    
    @discardableResult func loadData() -> Bool {
        if let data = UserDefaults.standard.data(forKey: "SavedCards"),
           let decoded = try? JSONDecoder().decode([Card].self, from: data) {
            cards = decoded
            return true
        } else {
            print("Error loading")
            return false
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
        if #available(iOS 15.0, *) {
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            ContentView()
        }
    }
}
