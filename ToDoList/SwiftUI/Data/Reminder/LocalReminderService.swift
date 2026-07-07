//
//  LocalReminderService.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 07.07.2026.
//

import Foundation
import UserNotifications

final class LocalReminderService: ReminderServiceProtocol {
    private let center: UNUserNotificationCenter
    
    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }
    
    func schedule(taskID: UUID, title: String, date: Date) async throws {
        guard date > Date() else {
            throw ReminderError.dateIsInPast
        }
        
        let isAllowed = try await center.requestAuthorization(options: [.alert, .sound])
        
        guard isAllowed else {
            throw ReminderError.permissionDenied
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Task reminder"
        content.body = title
        content.sound = .default
        
        let components = Calendar.current.dateComponents(
            [
                .year,
                .month,
                .day,
                .hour,
                .minute
            ],
            from: date
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: taskID.uuidString,
            content: content,
            trigger: trigger
        )

        try await center.add(request)
    }
    
    func cancel(taskID: UUID) {
        center.removePendingNotificationRequests(
            withIdentifiers: [taskID.uuidString]
        )
    }
}


enum ReminderError: LocalizedError {
    case dateIsInPast
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .dateIsInPast:
            return "Choose a future reminder date."

        case .permissionDenied:
            return "Notification permission is disabled."
        }
    }
}
