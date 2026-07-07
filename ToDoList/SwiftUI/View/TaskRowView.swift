//
//  TaskRowView.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 03.07.2026.
//

import SwiftUI

struct TaskRowView: View {
    let task: ToDoTask
    let onToggle: () -> Void
    let onToggleImportant: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: onToggle) {
                Image(
                    systemName: task.isCompleted
                    ? "checkmark.circle.fill"
                    : "circle"
                )
                .font(.title3)
                .foregroundColor(.yellow)
                .symbolEffect(.bounce, value: task.isCompleted)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)
                    .lineLimit(2)
            

            if let details = task.details,
               !details.isEmpty {
                Text(details)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
                
            HStack(spacing: 10) {
                if let createdAt = task.createdAt {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                        Text(
                            createdAt,
                            format: .dateTime
                                .day()
                                .month()
                                .year()
                        )
                    }
                    .foregroundStyle(.tertiary)
                }

                if task.reminderDate != nil {
                    Image(systemName: "bell.fill")
                        .font(.caption)
                    .foregroundColor(task.isCompleted ? .secondary : .orange)
                }
            }
            .font(.caption)
         }
            Spacer()

            Button(action: onToggleImportant) {
                Image(systemName: task.isImportant ? "star.fill" : "star")
                    .font(.body)
                    .foregroundColor(task.isImportant ? .yellow : .secondary)
                    .symbolEffect(.bounce, value: task.isImportant)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
        .animation(.easeInOut(duration: 0.2), value: task.reminderDate)
        .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
    }
    
}

#Preview {
    TaskRowView(task: ToDoTask(
        title: "Изучить SwiftUI",
        isCompleted: false
    ),
    onToggle: {},
    onToggleImportant: {}
    )
    .padding()
}
