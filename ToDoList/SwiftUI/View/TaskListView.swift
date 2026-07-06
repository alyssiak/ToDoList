//
//  TaskListView.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 02.07.2026.
//

import SwiftUI

private enum EditorRoute: Identifiable {
    case create
    case edit(ToDoTask)
    
    var id: String {
        switch self {
            case .create: return "create"
            case .edit(let task): return task.id.uuidString
        }
    }
}
struct ToDoTask: Identifiable, Sendable {
    let id: UUID
    let title: String
    var isCompleted: Bool

    init(
       id: UUID = UUID(),
       title: String,
       isCompleted: Bool
    ) {
       self.id = id
       self.title = title
       self.isCompleted = isCompleted
    }
}

struct TaskListView: View {
    @ObservedObject private var presenter: TaskListPresenter
    @State private var editorRoute: EditorRoute?
    
    init(presenter: TaskListPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(presenter.filteredTasks) { task in
                    TaskRowView(task: task) {
                        presenter.toggleTask(task)
                    }
                    .swipeActions(
                        edge: .leading,
                        allowsFullSwipe: false
                    ) {
                        Button {
                            editorRoute = .edit(task)
                        } label: {
                            Label(
                                "Редактировать",
                                systemImage: "pencil"
                            )
                        }
                        .tint(.blue)
                    }
                }
                .onDelete { offsets in
                    presenter.deleteTasks(
                        at: offsets,
                        from: presenter.filteredTasks
                    )
                }
            }
            .overlay {
                if presenter.filteredTasks.isEmpty {
                    if presenter.searchText.isEmpty {
                        ContentUnavailableView {
                            Label(
                                "Нет задач",
                                systemImage: "checklist"
                            )
                        } description: {
                            Text("Создай свою первую задачу")
                        }
                    } else {
                        ContentUnavailableView {
                            Label(
                                "Ничего не найдено",
                                systemImage: "magnifyingglass"
                            )
                        } description: {
                            Text(
                                "Попробуй изменить поисковый запрос"
                            )
                        }
                    }
                }
            }
            .navigationTitle("Список задач")
            .searchable(
                text: $presenter.searchText,
                prompt: "Поиск"
            )
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Text(presenter.taskCountText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Button {
                        editorRoute = .create
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .accessibilityLabel("Добавить задачу")
                }
            }
            .sheet(item: $editorRoute) { route in
                switch route {
                    case .create:
                        TaskEditorView(
                            navigationTitle: "Новая задача",
                            saveButtonTitle: "Добавить"
                        ) { title in
                            presenter.addTask(title: title)
                        }
                        
                    case .edit(let task):
                        TaskEditorView(
                            initialTitle: task.title,
                            navigationTitle: "Редактирование",
                            saveButtonTitle: "Сохранить"
                        ) { title in
                            presenter.updateTask(
                                id: task.id,
                                title: title
                            )
                        }
                }
            }
            .task {
                await presenter.loadTasks()
            }
        }
    }
    
    #Preview {
        let repository = CoreDataTaskRepository(stack: .shared)
        let interactor = TaskListInteractor(repository: repository)
        let presenter = TaskListPresenter(interactor: interactor)
        
        TaskListView(presenter: presenter)
    }
}
