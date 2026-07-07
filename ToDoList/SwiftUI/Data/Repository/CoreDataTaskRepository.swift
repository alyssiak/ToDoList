//
//  CoreDataTaskRepository.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 04.07.2026.
//

import CoreData

final class CoreDataTaskRepository: TaskRepositoryProtocol {
    private let stack: CoreDataStack
    
    init(stack: CoreDataStack) {
        self.stack = stack
    }
    
    func fetchTasks(
        matching query: String?
    ) async throws -> [ToDoTask] {
        let context = stack.backgroundContext()

        return try await context.perform {
            let request: NSFetchRequest<TaskItem> =
                TaskItem.fetchRequest()

            request.sortDescriptors = [
                NSSortDescriptor(
                    key: "createdAt",
                    ascending: false
                )
            ]

            if let query, !query.isEmpty {
                request.predicate = NSPredicate(
                    format: "title CONTAINS[cd] %@",
                    query
                )
            }

            let items = try context.fetch(request)
            let now = Date()
            var hasExpiredReminders = false

            let tasks = items.compactMap { item -> ToDoTask? in
                guard
                    let id = item.id,
                    let title = item.title
                else {
                    return nil
                }

                if let reminderDate = item.reminderDate,
                   reminderDate <= now {
                    item.reminderDate = nil
                    hasExpiredReminders = true
                }

                return ToDoTask(
                    id: id,
                    title: title,
                    details: item.desc,
                    isCompleted: item.isCompleted,
                    isImportant: item.isImportant,
                    createdAt: item.createdAt,
                    reminderDate: item.reminderDate
                )
            }

            if hasExpiredReminders {
                try context.save()
            }

            return tasks
        }
    }

    func createTask(
        title: String,
        details: String?,
        reminderDate: Date?,
        isImportant: Bool
    ) async throws -> ToDoTask {
        let context = stack.backgroundContext()

        return try await context.perform {
            let id = UUID()
            let createdAt = Date()
            let item = TaskItem(context: context)
            
            item.id = id
            item.title = title
            item.desc = details
            item.createdAt = createdAt
            item.isCompleted = false
            item.isImportant = isImportant
            item.reminderDate = reminderDate

            try context.save()
            
            return ToDoTask(
                id: id,
                title: title,
                details: details,
                isCompleted: false,
                isImportant: isImportant,
                createdAt: createdAt,
                reminderDate: reminderDate
            )
        }
    }

    func updateTask(
        id: UUID,
        title: String,
        details: String?,
        reminderDate: Date?,
        isImportant: Bool
    ) async throws {
        let context = stack.backgroundContext()
        
        try await context.perform {
            let item = try self.fetchItem(
                id: id,
                in: context
            )
            
            item.title = title
            item.desc = details
            item.reminderDate = reminderDate
            item.isImportant = isImportant
            try context.save()
        }
    }
    func toggleTask(id: UUID) async throws {
        let context = stack.backgroundContext()

        try await context.perform {
            let item = try self.fetchItem(
                id: id,
                in: context
            )

            item.isCompleted.toggle()

            if item.isCompleted {
                item.reminderDate = nil
            }

            try context.save()
        }
    }

    func toggleImportant(id: UUID) async throws {
        let context = stack.backgroundContext()

        try await context.perform {
            let item = try self.fetchItem(
                id: id,
                in: context
            )

            item.isImportant.toggle()
            try context.save()
        }
    }

    func deleteTask(id: UUID) async throws {
        let context = stack.backgroundContext()

        try await context.perform {
            let item = try self.fetchItem(
                id: id,
                in: context
            )

            context.delete(item)
            try context.save()
        }
    }

    func importTasks(_ tasks: [TaskSeed]) async throws {
        let context = stack.backgroundContext()

        try await context.perform {
            let creationDate = Date()

            for task in tasks {
                let item = TaskItem(context: context)
                item.id = UUID()
                item.title = task.title
                item.createdAt = creationDate
                item.isCompleted = task.isCompleted
                item.isImportant = false
            }

            try context.save()
        }
    }

    private func fetchItem(
        id: UUID,
        in context: NSManagedObjectContext
    ) throws -> TaskItem {
        let request: NSFetchRequest<TaskItem> =
            TaskItem.fetchRequest()

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )

        guard let item = try context.fetch(request).first else {
            throw TaskRepositoryError.taskNotFound
        }

        return item
    }
}


enum TaskRepositoryError: LocalizedError {
    case taskNotFound

    var errorDescription: String? {
        switch self {
        case .taskNotFound:
            return NSLocalizedString(
                "repository_error_task_not_found",
                comment: "Error shown when a task cannot be found"
            )
        }
    }
}
