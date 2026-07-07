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
            task.title.localizedCaseInsensitiveContains(query) || task.details?.localizedCaseInsensitiveContains(query) == true
        }
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
                try await interactor.toggleTask(task)
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
    
    func toggleImportant(_ task: ToDoTask) {
        Task {
            do {
                try await interactor.toggleImportant(id: task.id)
                await reloadTasks()
            } catch {
                handle(error)
            }
        }
    }

    func addTask(title: String, details: String?, reminderDate: Date?, isImportant: Bool) {
        Task {
            do {
                try await interactor.createTask(
                    title: title,
                    details: details,
                    reminderDate: reminderDate,
                    isImportant: isImportant
                )
                await reloadTasks()
            } catch {
                handle(error)
            }
        }
    }
    
    func updateTask(id: UUID, title: String, details: String?, reminderDate: Date?, isImportant: Bool) {
       Task {
            do {
                try await interactor.updateTask(
                    id: id,
                    title: title,
                    details: details,
                    reminderDate: reminderDate,
                    isImportant: isImportant
                )
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

    func importSampleTasks() {
        Task {
            isLoading = true

            defer {
                isLoading = false
            }

            do {
                try await interactor.importSampleTasks()
                await reloadTasks()
            } catch {
                handle(error)
            }
        }
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
