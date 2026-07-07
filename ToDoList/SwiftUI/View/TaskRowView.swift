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
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(task.title)
                        .font(.headline)

                    if task.reminderDate != nil {
                        Image(systemName: "bell.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
            

            if let details = task.details,
               !details.isEmpty {
                Text(details)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
                
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
                .font(.caption)
                .foregroundStyle(.tertiary)
            }
         }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TaskRowView(task: ToDoTask(
        title: "Изучить SwiftUI",
        isCompleted: false
    ),
    onToggle: {}
    )
    .padding()
}
