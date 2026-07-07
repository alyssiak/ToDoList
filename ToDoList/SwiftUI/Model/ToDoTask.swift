//
//  ToDoTask.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 06.07.2026.
//

import Foundation

struct ToDoTask: Identifiable, Sendable {
    let id: UUID
    let title: String
    let details: String?
    var isCompleted: Bool
    var isImportant: Bool
    let createdAt: Date?
    let reminderDate: Date?
    
    init(
        id: UUID = UUID(),
        title: String,
        details: String? = nil,
        isCompleted: Bool,
        isImportant: Bool = false,
        createdAt: Date? = Date(),
        reminderDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.isCompleted = isCompleted
        self.isImportant = isImportant
        self.createdAt = createdAt
        self.reminderDate = reminderDate
    }
}
