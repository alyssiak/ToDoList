//
//  TaskListAssembly.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 03.07.2026.
//

import SwiftUI


final class TaskListAssembly {
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    @MainActor
    func makeView() -> RootView {
        let interactor = TaskListInteractor(
            repository: container.taskRepository
        )
        
        let router = TaskListRouter()
        
        let presenter = TaskListPresenter(
            interactor: interactor,
            router: router
        )
        
        return RootView(
            presenter: presenter,
            router: router
        )
    }
}
