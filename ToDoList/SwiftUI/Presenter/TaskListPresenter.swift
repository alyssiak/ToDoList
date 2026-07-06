//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 03.07.2026.
//

import Foundation
import Combine

struct TaskListAlert: Identifiable {
    var id = UUID()
    var message: String
}

@MainActor
final class TaskListPresenter: ObservableObject {
    //MARK: - Property
    @Published private(set) var tasks: [ToDoTask] = []
    @Published private(set) var isLoading = false

    @Published var searchText = ""
    @Published var presentedError: TaskListAlert?
    
    private let interactor: TaskListInteractorProtocol
    private let router: TaskListRouterProtocol
    
    var filteredTasks: [ToDoTask] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return tasks
        }
        
        return tasks.filter { task in
            task.title.localizedCaseInsensitiveContains(query)
        }
    }
    
    var taskCountText: String {
        let count = tasks.count
        let remainder100 = count % 100
        let remainder10 = count % 10
        
        let word: String
        
        if remainder100 >= 11 && remainder100 <= 14 {
            word = "задач"
        } else {
            switch remainder10 {
                case 1: word = "задача"
                case 2...4: word = "задачи"
                default: word = "задач"
            }
        }
        
        return "\(count) \(word)"
    }
    
    //MARK: - Init
    init(interactor: TaskListInteractorProtocol, router: TaskListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    //MARK: - Public Methods
    func loadTasks() async {
        await reloadTasks()
    }
    
    func toggleTask(_ task: ToDoTask) {
        Task {
            do {
                try await interactor.toggleTask(id: task.id)
                await reloadTasks()
            } catch {
                handle(error)
            }
        }
    }
    
    func deleteTasks(at offsets: IndexSet, from displayedTasks: [ToDoTask]) {
        let ids = offsets.map { index in
            displayedTasks[index].id
        }
        
        Task {
            do {
                for id in ids {
                    try await interactor.deleteTask(id: id)
                }
                await reloadTasks()
            } catch {
                handle(error)
            }
        }
    }
    
    func addTask(title: String) {
        Task {
            do {
                try await interactor.createTask(title: title)
                await reloadTasks()
            } catch {
                handle(error)
            }
        }
    }
    
    func updateTask(id: UUID, title: String) {
       Task {
            do {
                try await interactor.updateTask(id: id, title: title)
                await reloadTasks()
            } catch {
                handle(error)
            }
        }
    }
    
    func addButtonTapped() {
        router.showCreate()
    }
    
    func editButtonTapped(_ task: ToDoTask) {
        router.showEdit(task)
    }
    
    //MARK: - Private methods
    private func reloadTasks() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            tasks = try await interactor.fetchTasks(
                matching: nil
            )
        } catch {
            handle(error)
        }
    }
    
    private func handle(_ error: Error) {
        presentedError = TaskListAlert(message: error.localizedDescription)
    }
}
