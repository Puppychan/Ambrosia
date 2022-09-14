//
//  SplashView.swift
//  Ambrosia
//
//  Created by Nhung Tran on 10/09/2022.
//

import SwiftUI

struct SplashView: View {
    @State var animationValues: [Bool] = Array(repeating: false, count: Constants.SPLASH_ANIMATION_ARRAY)
    
    let nearFinalIndex = 6
    let finalIndex = 7
    
    @State private var outerCircle: CGFloat = 170.0
    @State private var titleSize: CGFloat = 0.0
    @State private var footerSize: CGFloat = 0.0
    
    @State private var title = "A"
    @State private var title2 = ""
    @State private var footer = "I"
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Home View
                LaunchView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .offset(y: animationValues[nearFinalIndex] ? 0 : (geo.size.height + 50))
                
                if !animationValues[finalIndex] {
                    // MARK: - Splash View
                    StaticSplashView(animationValues: animationValues, outerCircle: outerCircle, titleSize: titleSize, footerSize: footerSize, title: title, title2: title2, footer: footer)
                    .opacity(animationValues[nearFinalIndex] ? 0 : 1)
                    .onAppear() {
                        outerCircle = geo.size.width / 2.43
                        titleSize = geo.size.width / 6.9
                        footerSize = geo.size.width / 20.6
                    }
                }
                
            }
            .ignoresSafeArea()
            .onAppear() {
                // MARK: - animation
                withAnimation(.interpolatingSpring(mass: 0.4, stiffness: 20, damping: 2, initialVelocity: 7)) {
                    // inner icon
                    animationValues[0] = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // inner circle
                    withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
                        animationValues[1] = true
                    }
                    // outer circle
                    withAnimation(.easeInOut(duration: 0.3).delay(0.45)) {
                        animationValues[2] = true
                    }
                    // text moving up
                    withAnimation(.easeInOut(duration: 0.4).delay(0.4)) {
                        animationValues[3] = true
                        footer = "Illuminati Group".uppercased()
                    }
                    // text appear horizontally
                    withAnimation(.spring(response: 1, dampingFraction: 0.45, blendDuration: 0.4).delay(1)) {
                        title = "Ambr".uppercased()
                        title2 = "osia".uppercased()
                        animationValues[4] = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.interpolatingSpring(mass: 1, stiffness: 20, damping: 1.3, initialVelocity: 3).delay(0.9)) {
                                animationValues[5] = true
                            }
                        }
                    }
                    
                    // restoring back
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                        withAnimation(.easeInOut(duration: 0.3).delay(0.4)) {
                            animationValues[3] = false
                        }
                        // end splash screen
                        withAnimation(.easeInOut(duration: 0.5).delay(0.8)) {
                            animationValues[nearFinalIndex] = true
                        }
                        
                        // for removing splash view after 2s
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            animationValues[finalIndex] = true
                        }
                        
                    }
                }
                
            }
        }
    }
}
