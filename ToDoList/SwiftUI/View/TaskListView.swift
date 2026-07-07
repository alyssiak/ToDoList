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
                .navigationTitle("task_list_title")
                .searchable(
                    text: $presenter.searchText,
                    prompt: "search_prompt"
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
                        title: Text("error_title"),
                        message: Text(alert.message),
                        dismissButton: .default(Text("ok_button"))
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
                            "edit_task",
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
            ProgressView("loading")
        } else if presenter.filteredTasks.isEmpty {
            if presenter.searchText.isEmpty {
                ContentUnavailableView {
                    Label(
                        "empty_title",
                        systemImage: "checklist"
                    )
                } description: {
                    Text("empty_description")
                }
            } else {
                ContentUnavailableView {
                    Label(
                        "nothing_found_title",
                        systemImage: "magnifyingglass"
                    )
                } description: {
                    Text("nothing_found_description")
                }
            }
        }
    }

    var topToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Section("language_section") {
                    ForEach(AppLanguage.allCases) { language in
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                settings.language = language
                            }
                        } label: {
                            Label(
                                language.titleKey,
                                systemImage: settings.language == language
                                ? "checkmark.circle.fill"
                                : language.iconName
                            )
                        }
                    }
                }

                Section("actions_section") {
                    Button {
                        presenter.importSampleTasks()
                    } label: {
                        Label(
                            "import_sample_tasks",
                            systemImage: "square.and.arrow.down"
                        )
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .accessibilityLabel("more_actions")
        }
    }

    var bottomToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            themeMenu

            Spacer()

            Text(settings.language.taskCountText(for: presenter.tasks.count))
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()

            Button {
                presenter.addButtonTapped()
            } label: {
                Image(systemName: "square.and.pencil")
            }
            .accessibilityLabel("add_task_accessibility")
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
                        theme.titleKey,
                        systemImage: settings.theme == theme
                        ? "checkmark.circle.fill"
                        : theme.iconName
                    )
                }
            }
        } label: {
            Image(systemName: "circle.lefthalf.filled")
        }
        .accessibilityLabel("change_theme")
    }

    @ViewBuilder
    func editorSheet(for route: TaskListRoute) -> some View {
        switch route {
        case .create:
            TaskEditorView(
                navigationTitle: "new_task_title",
                saveButtonTitle: "add_button"
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
                navigationTitle: "edit_task_title",
                saveButtonTitle: "save_button"
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
