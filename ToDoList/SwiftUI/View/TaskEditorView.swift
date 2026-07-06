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
    @State private var details: String
    
    let navigationTitle: String
    let saveButtonTitle: String
    let onSave: (String, String?) -> Void
    
    init(
        initialTitle: String = "",
        initialDetails: String? = nil,
        navigationTitle: String,
        saveButtonTitle: String,
        onSave: @escaping (String, String?) -> Void
    ) {
        _title = State(initialValue: initialTitle)
        _details = State(initialValue: initialDetails ?? "")
        self.navigationTitle = navigationTitle
        self.saveButtonTitle = saveButtonTitle
        self.onSave = onSave
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField(
                        "Task title",
                        text: $title
                    )
                }
                
                Section("Description") {
                    TextEditor(text: $details)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(saveButtonTitle) {
                        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        let cleanDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        onSave(
                            cleanTitle,
                            cleanDetails.isEmpty ? nil : cleanDetails
                        )
                        
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
    ) { title, details in
        print(title, details ?? "")
    }
}
