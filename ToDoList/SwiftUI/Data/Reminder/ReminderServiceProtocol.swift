//
//  ReminderServiceProtocol.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 07.07.2026.
//

import Foundation

protocol ReminderServiceProtocol {
    func schedule(
        taskID: UUID,
        title: String,
        date: Date
    ) async throws
    
    func cancel(taskID: UUID)
}
