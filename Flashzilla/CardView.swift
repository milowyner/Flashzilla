//
//  CardView.swift
//  Flashzilla
//
//  Created by Milo Wyner on 9/24/21.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled

    let card: Card
    var removal: ((Bool) -> Void)? = nil
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    let feedback = UINotificationFeedbackGenerator()
    
    var backgroundColor: Color {
        if offset.width > 0 {
            return Color.green
        } else if offset.width < 0 {
            return Color.red
        } else {
            return Color.white
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? Color.white
                    : Color.white.opacity(1.0 - abs(offset.width / 50.0))
                )
                .shadow(radius: 10)
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(backgroundColor)
                )
            
            VStack {
                if accessibilityEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2.0 - abs(offset.width / 50.0))
        .accessibility(addTraits: .isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            feedback.notificationOccurred(.success)
                            withAnimation {
                                removal?(true)
                            }
                        } else {
                            feedback.notificationOccurred(.error)
                            offset = CGSize.zero
                            removal?(false)
                        }
                    } else {
                        withAnimation {
                            offset = .zero
                        }
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
