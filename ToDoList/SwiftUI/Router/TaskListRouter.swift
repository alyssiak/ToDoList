//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 06.07.2026.
//

import Combine
import Foundation

enum TaskListRoute: Identifiable {
    case create
    case edit(ToDoTask)
    
    var id: String {
        switch self {
            case .create: return "create"
            case .edit(let task): return task.id.uuidString
        }
    }
}

@MainActor
protocol TaskListRouterProtocol: AnyObject {
    func showCreate()
    func showEdit(_ task: ToDoTask)
    func dismiss()
}


@MainActor
final class TaskListRouter: ObservableObject, TaskListRouterProtocol {
    @Published var presentedRoute: TaskListRoute?
    
    func showCreate() {
        presentedRoute = .create
    }
    
    func showEdit(_ task: ToDoTask) {
        presentedRoute = .edit(task)
    }
    
    func dismiss() {
        presentedRoute = nil
    }
}
