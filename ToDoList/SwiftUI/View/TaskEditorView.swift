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
    @State private var hasReminder: Bool
    @State private var reminderDate: Date
    
    let navigationTitle: String
    let saveButtonTitle: String
    let onSave: (String, String?, Date?) -> Void
    
    init(
        initialTitle: String = "",
        initialDetails: String? = nil,
        initialReminderDate: Date? = nil,
        navigationTitle: String,
        saveButtonTitle: String,
        onSave: @escaping (String, String?, Date?) -> Void
    ) {
        _title = State(initialValue: initialTitle)
        _details = State(initialValue: initialDetails ?? "")
        _hasReminder = State(initialValue: initialReminderDate != nil)
        _reminderDate = State(initialValue: initialReminderDate ?? Date().addingTimeInterval(3600))
        
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
                
                Section("Reminder") {
                    Toggle(
                        "Enable reminder",
                        isOn: $hasReminder
                    )
                    
                    if hasReminder {
                        DatePicker(
                            "Date and time",
                            selection: $reminderDate,
                            in: Date()...,
                            displayedComponents: [
                                .date,
                                .hourAndMinute
                            ]
                        )
                    }
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
                            cleanDetails.isEmpty ? nil : cleanDetails,
                            hasReminder ? reminderDate : nil
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
    ) { title, details, reminderDate in
        print(title, details ?? "", reminderDate as Any)
    }
}
