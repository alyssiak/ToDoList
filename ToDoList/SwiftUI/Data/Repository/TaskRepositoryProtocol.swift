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
    
    func createTask(title: String, details: String?, reminderDate: Date?, isImportant: Bool) async throws -> ToDoTask
    func updateTask(id: UUID, title: String, details: String?, reminderDate: Date?, isImportant: Bool) async throws
    func toggleTask(id: UUID) async throws
    func toggleImportant(id: UUID) async throws
    func deleteTask(id: UUID) async throws
    func importTasks(_ tasks: [TaskSeed]) async throws
}
