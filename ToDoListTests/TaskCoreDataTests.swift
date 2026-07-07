import XCTest
@testable import ToDoList

final class TaskCoreDataTests: XCTestCase {
    private var repository: CoreDataTaskRepository!
    
    override func setUp() {
        super.setUp()
        let stack = CoreDataStack(inMemory: true)
        repository = .init(stack: stack)
    }
    
    override func tearDown() {
        repository = nil
        super.tearDown()
    }
    
    func testCreateAndFetchTask() async throws {
            let reminderDate = Date().addingTimeInterval(3600)

            _ = try await repository.createTask(
                title: "Test task",
                details: "Some description",
                reminderDate: reminderDate,
                isImportant: true
            )

            let tasks = try await repository.fetchTasks(matching: nil)

            XCTAssertEqual(tasks.count, 1)
            XCTAssertEqual(tasks.first?.title, "Test task")
            XCTAssertEqual(tasks.first?.details, "Some description")
            XCTAssertEqual(tasks.first?.isCompleted, false)
            XCTAssertEqual(tasks.first?.isImportant, true)
            XCTAssertNotNil(tasks.first?.reminderDate)
        }

        func testToggleCompletedClearsReminder() async throws {
            let task = try await repository.createTask(
                title: "Task with reminder",
                details: nil,
                reminderDate: Date().addingTimeInterval(3600),
                isImportant: false
            )

            try await repository.toggleTask(id: task.id)

            let tasks = try await repository.fetchTasks(matching: nil)

            XCTAssertEqual(tasks.first?.isCompleted, true)
            XCTAssertNil(tasks.first?.reminderDate)
        }

        func testToggleImportant() async throws {
            let task = try await repository.createTask(
                title: "Important later",
                details: nil,
                reminderDate: nil,
                isImportant: false
            )

            try await repository.toggleImportant(id: task.id)

            let tasks = try await repository.fetchTasks(matching: nil)

            XCTAssertEqual(tasks.first?.isImportant, true)
        }

        func testExpiredReminderIsClearedOnFetch() async throws {
            _ = try await repository.createTask(
                title: "Expired reminder",
                details: nil,
                reminderDate: Date().addingTimeInterval(-3600),
                isImportant: false
            )

            let tasks = try await repository.fetchTasks(matching: nil)

            XCTAssertNil(tasks.first?.reminderDate)
        }

        func testDeleteTask() async throws {
            let task = try await repository.createTask(
                title: "Delete task",
                details: nil,
                reminderDate: nil,
                isImportant: false
            )

            try await repository.deleteTask(id: task.id)

            let tasks = try await repository.fetchTasks(matching: nil)

            XCTAssertTrue(tasks.isEmpty)
        }
}
