//
//  home30App.swift
//  home30
//
//  Created by Nataly on 25.04.2023.
//

import SwiftUI

struct LockScreenView: View {
    @State private var sliderValue = 0.0
    @State private var isUnlocked = false
    let sliderMaxValue: Double = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("MainScreen")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text("")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    UnlockSlider(sliderValue: $sliderValue, maxValue: sliderMaxValue, onUnlock: {
                        isUnlocked = true
                    })
                    .padding(.horizontal, 50)
                }
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink(
                    destination: SecondScreenView(sliderValue: $sliderValue, isUnlocked: $isUnlocked), 
                    isActive: $isUnlocked,
                    label: { EmptyView() }
                )
            )
        }
        .navigationBarHidden(true)
    }
}

struct UnlockSlider: View {
    @Binding var sliderValue: Double
    let maxValue: Double
    let onUnlock: () -> Void
    @State private var isUnlocked = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                BackgroundComponent()
                DraggingComponent(maxWidth: geometry.size.width, onUnlock: {
                    isUnlocked = true
                    onUnlock()
                    sliderValue = 0
                })
            }
        }
        .frame(height: 50)
            }
        }


struct BackgroundComponent: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule(style: .continuous)

                .fill(Color.gray.opacity(0.4))
            
            Text("Slide to unlock")
                .font(.footnote)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
}

struct DraggingComponent: View {
    let maxWidth: CGFloat
    private let minWidth: CGFloat = 50
    @State private var width: CGFloat = 50
    @State var isAnimated: Bool = false
    let onUnlock: () -> Void
    
    var body: some View {
        Capsule(style: .continuous)
            .fill(Color.gray)
            .frame(width: width)
            .overlay(
                ZStack {
                    image(name: "lock", isShown: width < maxWidth)
                    image(name: "lock.open", isShown: width >= maxWidth)
                },
                alignment: .trailing
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width > 0 {
                            width = min(max(value.translation.width + minWidth, minWidth), maxWidth)
                        }
                    }
                    .onEnded { value in
                        if width < maxWidth {
                            width = minWidth
                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                        } else {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            withAnimation(.spring().delay(0.5)) {
                                onUnlock()
                            }
                            withAnimation {
                                isAnimated = true
                            }
                            withAnimation(.default.delay(0.8)) {
                                isAnimated = false
                            }
                        }
                    }
            )
            .animation(.spring(response: 0.7, dampingFraction: 1, blendDuration: 0), value: width)
            .onChange(of: isAnimated) { newValue in
                if !newValue {
                    width = minWidth
                }
            }
    }
    
    private func image(name: String, isShown: Bool) -> some View {
        Image(systemName: name)
            .font(.system(size: 20, weight: .regular, design: .rounded))
            .foregroundColor(Color.gray)
            .frame(width: 42, height: 42)
            .background(Capsule().fill(.white))
            .padding(4)
            .opacity(isShown ? 1 : 0)
            .scaleEffect(isShown ? 1 : 0.01)
    }
}



