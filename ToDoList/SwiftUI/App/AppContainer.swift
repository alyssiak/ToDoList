//
//  AppContainer.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 04.07.2026.
//

import Foundation

final class AppContainer {
    let coreDataStack: CoreDataStack
    let urlSession: URLSession
    let userDefaults: UserDefaults
    let taskRepository: TaskRepositoryProtocol
    let taskAPIClient: TaskAPIClientProtocol
    let reminderService: ReminderServiceProtocol
    
    init(
        coreDataStack: CoreDataStack = .shared,
        urlSession: URLSession = .shared,
        userDefaults: UserDefaults = .standard,
        taskRepository: TaskRepositoryProtocol? = nil,
        taskAPIClient: TaskAPIClientProtocol? = nil,
        reminderService: ReminderServiceProtocol? = nil
    ) {
        self.coreDataStack = coreDataStack
        self.urlSession = urlSession
        self.userDefaults = userDefaults
        self.taskRepository = taskRepository ?? CoreDataTaskRepository(stack: coreDataStack)
        self.taskAPIClient = taskAPIClient ?? TaskAPIClient(session: urlSession)
        self.reminderService = reminderService ?? LocalReminderService()
    }
    
    
}
