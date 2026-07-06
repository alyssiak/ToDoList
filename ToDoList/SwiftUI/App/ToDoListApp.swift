//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 06.07.2026.
//

import SwiftUI

@main
@MainActor
struct ToDoListApp: App {
    private let rootView: RootView
    
    init() {
        let container = AppContainer()
        let assembly = TaskListAssembly(container: container)
        rootView = assembly.makeView()
    }
    
    var body: some Scene {
        WindowGroup {
            rootView
                .tint(.yellow)
        }
    }
}
