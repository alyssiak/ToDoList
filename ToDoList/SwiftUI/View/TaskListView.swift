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
    @EnvironmentObject private var settings: AppSettings

    init(presenter: TaskListPresenter, router: TaskListRouter) {
        self.presenter = presenter
        self.router = router
    }

    var body: some View {
        NavigationStack {
            taskList
                .overlay {
                    emptyOrLoadingState
                }
                .navigationTitle("Список задач")
                .searchable(
                    text: $presenter.searchText,
                    prompt: "Поиск"
                )
                .toolbar {
                    topToolbar
                    bottomToolbar
                }
                .sheet(item: $router.presentedRoute) { route in
                    editorSheet(for: route)
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
}

private extension TaskListView {
    var taskList: some View {
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
                .contentShape(Rectangle())
                .onTapGesture {
                    presenter.editButtonTapped(task)
                }
            }
            .onDelete { offsets in
                presenter.deleteTasks(
                    at: offsets,
                    from: presenter.filteredTasks
                )
            }
        }
    }

    @ViewBuilder
    var emptyOrLoadingState: some View {
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
                    Text("Попробуй изменить поисковый запрос")
                }
            }
        }
    }

    var topToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Section("Actions") {
                    Button {
                        presenter.importSampleTasks()
                    } label: {
                        Label(
                            "Import sample tasks",
                            systemImage: "square.and.arrow.down"
                        )
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .accessibilityLabel("More actions")
        }
    }

    var bottomToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            themeMenu

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

    var themeMenu: some View {
        Menu {
            ForEach(AppTheme.allCases) { theme in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        settings.theme = theme
                    }
                } label: {
                    Label(
                        theme.title,
                        systemImage: settings.theme == theme
                        ? "checkmark.circle.fill"
                        : theme.iconName
                    )
                }
            }
        } label: {
            Image(systemName: "circle.lefthalf.filled")
        }
        .accessibilityLabel("Change theme")
    }

    @ViewBuilder
    func editorSheet(for route: TaskListRoute) -> some View {
        switch route {
        case .create:
            TaskEditorView(
                navigationTitle: "Новая задача",
                saveButtonTitle: "Добавить"
            ) { title, details, reminderDate in
                presenter.addTask(
                    title: title,
                    details: details,
                    reminderDate: reminderDate
                )
            }

        case .edit(let task):
            TaskEditorView(
                initialTitle: task.title,
                initialDetails: task.details,
                initialReminderDate: task.reminderDate,
                navigationTitle: "Редактирование",
                saveButtonTitle: "Сохранить"
            ) { title, details, reminderDate in
                presenter.updateTask(
                    id: task.id,
                    title: title,
                    details: details,
                    reminderDate: reminderDate
                )
            }
        }
    }
}

#Preview {
    let repository = CoreDataTaskRepository(stack: .shared)
    let apiClient = TaskAPIClient(session: .shared)
    let interactor = TaskListInteractor(
        repository: repository,
        apiClient: apiClient,
        userDefaults: .standard,
        reminderService: LocalReminderService()
    )
    let router = TaskListRouter()
    let presenter = TaskListPresenter(
        interactor: interactor,
        router: router
    )

    TaskListView(presenter: presenter, router: router)
        .environmentObject(AppSettings())
}
