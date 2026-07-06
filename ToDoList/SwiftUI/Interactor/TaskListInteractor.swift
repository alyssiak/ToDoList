//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 04.07.2026.
//

import Foundation

final class TaskListInteractor: TaskListInteractorProtocol {
    private let repository: TaskRepositoryProtocol
    
    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchTasks(matching query: String?) async throws -> [ToDoTask] {
        try await repository.fetchTasks(matching: query)
    }
    
    func createTask(title: String) async throws {
        try await repository.createTask(title: title)
    }

    func updateTask(
        id: UUID,
        title: String
    ) async throws {
        try await repository.updateTask(
            id: id,
            title: title
        )
    }

    func toggleTask(id: UUID) async throws {
        try await repository.toggleTask(id: id)
    }

    func deleteTask(id: UUID) async throws {
        try await repository.deleteTask(id: id)
    }
}
