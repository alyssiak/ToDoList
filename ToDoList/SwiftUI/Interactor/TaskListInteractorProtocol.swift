//
//  TaskListInteractorProtocol.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 04.07.2026.
//

import Foundation

protocol TaskListInteractorProtocol {
    func fetchTasks(
        matching query: String?,
    ) async throws -> [ToDoTask]
    
    func createTask(title: String, details: String?, reminderDate: Date?) async throws
    func updateTask(id: UUID, title: String, details: String?, reminderDate: Date?) async throws
    func toggleTask(_ task: ToDoTask) async throws
    func deleteTask(id: UUID) async throws
    func importSampleTasks() async throws
}
