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
    
    func makeView() -> TaskListView {
        let interactor = ToDoListInteractor()
        
        let presenter = TaskListPresenter(
            interactor: interactor
        )
        
        return TaskListView(
            presenter: presenter
        )
    }
}
