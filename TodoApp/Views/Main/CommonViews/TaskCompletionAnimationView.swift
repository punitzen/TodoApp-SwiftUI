//
//  TaskCompletionAnimationView.swift
//  TodoApp
//
//  Created by Punit Kumar on 07/03/26.
//

import SwiftUI

struct TaskCompletionAnimationView: View {
    @Binding var showTaskCompletionAnimation: Bool
    @State var lottieScale: CGFloat = 0
    @State var lottieOpacity: Double = 0
    @State var lottieXOffset: CGFloat = 0
    @State var lottieYOffset: CGFloat = 0
    @State var lottieZIndex: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                
            ZStack(alignment: .bottomLeading) {
                LottieView(animationName: Resources.Lottie.tick)
                    .frame(width: 100, height: 100)
                    .offset(x: lottieXOffset, y: lottieYOffset)
                    .scaleEffect(lottieScale)
                    .opacity(lottieOpacity)
                    .zIndex(lottieZIndex)
                    
                LottieView(animationName: Resources.Lottie.confetti)
                    .frame(width: 200, height: 200)
            }
            .padding(.horizontal, 50)
        }
        .onAppear {
            animateLottie()
        }
    }
    
    func animateLottie() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.6)) {
                lottieOpacity = 1
                lottieScale = 1.1
                lottieXOffset = 80
                lottieYOffset = -80
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    lottieScale = 1
                }
            }
            
            lottieZIndex = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.1)) {
                showTaskCompletionAnimation = false
            }
        }
    }
}
