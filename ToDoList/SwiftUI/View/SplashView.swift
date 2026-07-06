//
//  SplashView.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 04.07.2026.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimated = false

    var body: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
        
        Image("LaunchIcon")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .scaleEffect(isAnimated ? 1 : 0.7)
            .opacity(isAnimated ? 1 : 0)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    isAnimated = true
                }
            }
    }
}
