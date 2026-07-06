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
    
    init(id: UUID = UUID(), title: String, details: String? = nil, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.details = details
        self.isCompleted = isCompleted
    }
}
