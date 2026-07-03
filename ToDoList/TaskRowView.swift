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
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(
                    systemName: task.isCompleted
                    ? "checkmark.circle.fill"
                    : "circle"
                )
                .foregroundColor(.yellow)
            }.buttonStyle(.plain)
            
            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundStyle(task.isCompleted ? .secondary : .primary)
        }
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
