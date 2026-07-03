//
//  AddTaskView.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 03.07.2026.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    
    let onSave: (String) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Название задачи", text: $title)
            }
            .navigationTitle("Задача")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Добавить") {
                        onSave(title)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(
                        in: .whitespaces
                    ).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddTaskView { title in
        print(title)
    }
}
