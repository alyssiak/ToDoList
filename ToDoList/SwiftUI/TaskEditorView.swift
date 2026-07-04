//
//  TaskEditorView.swift
//  TaskEditorView
//
//  Created by Alice Kamyshenko on 03.07.2026.
//

import SwiftUI

struct TaskEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    
    let navigationTitle: String
    let saveButtonTitle: String
    let onSave: (String) -> Void
    
    init(
        initialTitle: String = "",
        navigationTitle: String,
        saveButtonTitle: String,
        onSave: @escaping (String) -> Void
    ) {
        _title = State(initialValue: initialTitle)
        self.navigationTitle = navigationTitle
        self.saveButtonTitle = saveButtonTitle
        self.onSave = onSave
    }
    
    
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
                    Button(saveButtonTitle) {
                        onSave(title)
                        dismiss()
                    }
                    .disabled(
                        title.trimmingCharacters(
                            in: .whitespaces
                    ).isEmpty)
                }
            }
        }
    }
}

#Preview {
    TaskEditorView(
        initialTitle: "Изучить SwiftUI",
        navigationTitle: "Редактирование",
        saveButtonTitle: "Сохранить"
    ) { title in
        print(title)
    }
}
