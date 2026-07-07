//
//  TaskListPresenterTests.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 07.07.2026.
//

import XCTest
@testable import ToDoList

@MainActor
final class MockTaskListInteractor: TaskListInteractorProtocol {
    var tasksToReturn: [ToDoTask] = []

        func fetchTasks(matching query: String?) async throws -> [ToDoTask] {
            tasksToReturn
        }

        func createTask(
            title: String,
            details: String?,
            reminderDate: Date?,
            isImportant: Bool
        ) async throws { }

        func updateTask(
            id: UUID,
            title: String,
            details: String?,
            reminderDate: Date?,
            isImportant: Bool
        ) async throws { }

        func toggleTask(_ task: ToDoTask) async throws { }

        func toggleImportant(id: UUID) async throws { }

        func deleteTask(id: UUID) async throws { }

        func importSampleTasks() async throws { }
}

@MainActor
final class MockTaskListRouter: TaskListRouterProtocol {
    var didShowCreate = false
    var editedTask: ToDoTask?

    func showCreate() {
        didShowCreate = true
    }

    func showEdit(_ task: ToDoTask) {
        editedTask = task
    }

    func dismiss() { }
}

@MainActor
final class TaskListPresenterTests: XCTestCase {
    func testLoadTasksUpdatesTasks() async {
        let interactor = MockTaskListInteractor()
        let router = MockTaskListRouter()

        let expectedTask = ToDoTask(
            title: "Read SwiftUI",
            details: "Practice views",
            isCompleted: false
        )

        interactor.tasksToReturn = [expectedTask]

        let presenter = TaskListPresenter(
            interactor: interactor,
            router: router
        )

        await presenter.loadTasks()

        XCTAssertEqual(presenter.tasks.count, 1)
        XCTAssertEqual(presenter.tasks.first?.title, "Read SwiftUI")
    }

    func testSearchFiltersByTitleAndDetails() async {
        let interactor = MockTaskListInteractor()
        let router = MockTaskListRouter()

        interactor.tasksToReturn = [
            ToDoTask(
                title: "Buy milk",
                details: nil,
                isCompleted: false
            ),
            ToDoTask(
                title: "Study",
                details: "SwiftUI architecture",
                isCompleted: false
            )
        ]

        let presenter = TaskListPresenter(
            interactor: interactor,
            router: router
        )

        await presenter.loadTasks()
        presenter.searchText = "swiftui"

        XCTAssertEqual(presenter.filteredTasks.count, 1)
        XCTAssertEqual(presenter.filteredTasks.first?.title, "Study")
    }

    func testAddButtonShowsCreateRoute() {
        let interactor = MockTaskListInteractor()
        let router = MockTaskListRouter()

        let presenter = TaskListPresenter(
            interactor: interactor,
            router: router
        )

        presenter.addButtonTapped()

        XCTAssertTrue(router.didShowCreate)
    }

    func testEditButtonShowsEditRoute() {
        let interactor = MockTaskListInteractor()
        let router = MockTaskListRouter()

        let task = ToDoTask(
            title: "Edit me",
            isCompleted: false
        )

        let presenter = TaskListPresenter(
            interactor: interactor,
            router: router
        )

        presenter.editButtonTapped(task)

        XCTAssertEqual(router.editedTask?.id, task.id)
    }
}
