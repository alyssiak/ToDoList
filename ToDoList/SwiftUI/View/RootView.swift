//
//  RootView.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 04.07.2026.
//

import SwiftUI

struct RootView: View {
    @StateObject private var presenter: TaskListPresenter
    @State private var isShowingContent = false

    init(presenter: TaskListPresenter) {
        _presenter = StateObject(
            wrappedValue: presenter
        )
    }

    var body: some View {
        ZStack {
            if isShowingContent {
                TaskListView(presenter: presenter)
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
