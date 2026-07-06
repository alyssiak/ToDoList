//
//  TaskRepositoryProtocol.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 04.07.2026.
//

import CoreData

protocol TaskRepositoryProtocol {
    func fetchTasks(
        matching query: String?
    ) async throws -> [ToDoTask]
    
    func createTask(title: String, details: String?) async throws
    func updateTask(id: UUID, title: String, details: String?) async throws
    func toggleTask(id: UUID) async throws
    func deleteTask(id: UUID) async throws
}
