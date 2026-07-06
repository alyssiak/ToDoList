//
//  RootView.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 04.07.2026.
//

import SwiftUI

struct RootView: View {
    @StateObject private var presenter: TaskListPresenter
    @StateObject private var router: TaskListRouter
    
    @State private var isShowingContent = false
    
    init(presenter: TaskListPresenter, router: TaskListRouter) {
        _presenter = StateObject(
            wrappedValue: presenter
        )
        
        _router = StateObject(
            wrappedValue: router
        )
    }

    var body: some View {
        ZStack {
            if isShowingContent {
                TaskListView(presenter: presenter, router: router)
                    .transition(.opacity)
            } else {
                SplashView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(
                for: .milliseconds(800)
            )

            withAnimation(.easeInOut(duration: 0.3)) {
                isShowingContent = true
            }
        }
    }
}
