//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 04.07.2026.
//

import Foundation

final class TaskListInteractor: TaskListInteractorProtocol {
    private let repository: TaskRepositoryProtocol
    private let apiClient: TaskAPIClientProtocol
    private let userDefaults: UserDefaults
    private let reminderService: ReminderServiceProtocol

    private let importKey = "hasImportedSampleTasks"
    
    init(
        repository: TaskRepositoryProtocol,
        apiClient: TaskAPIClientProtocol,
        userDefaults: UserDefaults,
        reminderService: ReminderServiceProtocol
    ) {
        self.repository = repository
        self.apiClient = apiClient
        self.userDefaults = userDefaults
        self.reminderService = reminderService
    }
    
    func fetchTasks(matching query: String?) async throws -> [ToDoTask] {
        try await repository.fetchTasks(matching: query)
    }
    
    func createTask(title: String, details: String?, reminderDate: Date?) async throws {
        let task = try await repository.createTask(
            title: title,
            details: details,
            reminderDate: reminderDate
        )

        if let reminderDate {
            try await reminderService.schedule(
                taskID: task.id,
                title: task.title,
                date: reminderDate
            )
        }
    }

    func updateTask(
        id: UUID,
        title: String,
        details: String?,
        reminderDate: Date?
    ) async throws {
        try await repository.updateTask(
            id: id,
            title: title,
            details: details,
            reminderDate: reminderDate
        )

        reminderService.cancel(taskID: id)

        if let reminderDate {
            try await reminderService.schedule(
                taskID: id,
                title: title,
                date: reminderDate
            )
        }
    }

    func toggleTask(_ task: ToDoTask) async throws {
        try await repository.toggleTask(id: task.id)
        if !task.isCompleted {
            reminderService.cancel(taskID: task.id)
        }
    }

    func deleteTask(id: UUID) async throws {
        try await repository.deleteTask(id: id)
        reminderService.cancel(taskID: id)
    }

    func importSampleTasks() async throws {
        guard !userDefaults.bool(forKey: importKey) else {
            throw TaskImportError.alreadyImported
        }

        let tasks = try await apiClient.fetchSampleTasks()
        try await repository.importTasks(tasks)
        userDefaults.set(true, forKey: importKey)
    }
}

enum TaskImportError: LocalizedError {
    case alreadyImported

    var errorDescription: String? {
        NSLocalizedString(
            "import_error_already_imported",
            comment: "Error shown when sample tasks were already imported"
        )
    }
}
