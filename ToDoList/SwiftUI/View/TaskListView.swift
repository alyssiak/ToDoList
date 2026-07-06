//
//  TaskListView.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 02.07.2026.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject private var presenter: TaskListPresenter
    @ObservedObject private var router: TaskListRouter
    
    init(presenter: TaskListPresenter, router: TaskListRouter) {
        self.presenter = presenter
        self.router = router
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
                            presenter.editButtonTapped(task)
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
                if presenter.isLoading {
                    ProgressView("Загрузка...")
                } else if presenter.filteredTasks.isEmpty {
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
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            presenter.importSampleTasks()
                        } label: {
                            Label(
                                "Import sample tasks",
                                systemImage: "square.and.arrow.down"
                            )
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .accessibilityLabel("More actions")
                }

                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Text(presenter.taskCountText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Button {
                        presenter.addButtonTapped()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .accessibilityLabel("Добавить задачу")
                }
            }
            .sheet(item: $router.presentedRoute) { route in
                switch route {
                    case .create:
                        TaskEditorView(
                            navigationTitle: "Новая задача",
                            saveButtonTitle: "Добавить"
                        ) { title, details in
                            presenter.addTask(title: title, details: details)
                        }
                        
                    case .edit(let task):
                        TaskEditorView(
                            initialTitle: task.title,
                            initialDetails: task.details,
                            navigationTitle: "Редактирование",
                            saveButtonTitle: "Сохранить"
                        ) { title, details in
                            presenter.updateTask(
                                id: task.id,
                                title: title,
                                details: details
                            )
                        }
                }
            }
            .task {
                await presenter.loadTasks()
            }
            .alert(item: $presenter.presentedError) { alert in
                Alert(
                    title: Text("Ошибка"),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    #Preview {
        let repository = CoreDataTaskRepository(stack: .shared)
        let apiClient = TaskAPIClient(session: .shared)
        let interactor = TaskListInteractor(
            repository: repository,
            apiClient: apiClient,
            userDefaults: .standard
        )
        let router = TaskListRouter()
        let presenter = TaskListPresenter(interactor: interactor, router: router)
        
        TaskListView(presenter: presenter, router: router)
    }
}
