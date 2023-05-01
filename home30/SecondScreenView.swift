//
//  SecondScreen.swift
//  home30
//
//  Created by Nataly on 26.04.2023.
//

import SwiftUI
struct SecondScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var sliderValue: Double
    @Binding var isUnlocked: Bool
    
    var body: some View {
        ZStack {
            Image("SecondScreen")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("")
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
            }
        }
        .onDisappear {
            sliderValue = 0
            isUnlocked = false
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Назад")
                }
            })
        )
    }
}
