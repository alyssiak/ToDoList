//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 03.07.2026.
//

import Foundation
import Combine

final class TaskListPresenter: ObservableObject {
    @Published private(set) var tasks  = [
        ToDoTask(title: "Изучить основы SwiftUI", isCompleted: false),
        ToDoTask(title: "Обновить README", isCompleted: true),
        ToDoTask(title: "Сделать иконку", isCompleted: false)
    ]
    
    @Published var searchText = ""
    
    private let interactor: ToDoListInteractorInput
    
    var filteredTasks: [ToDoTask] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return tasks
        }
        
        return tasks.filter { task in
            task.title.localizedCaseInsensitiveContains(query)
        }
    }
    
    var taskCountText: String {
        let count = tasks.count
        let remainder100 = count % 100
        let remainder10 = count % 10
        
        let word: String
        
        if remainder100 >= 11 && remainder100 <= 14 {
            word = "задач"
        } else {
            switch remainder10 {
                case 1: word = "задача"
                case 2...4: word = "задачи"
                default: word = "задач"
            }
        }
        
        return "\(count) \(word)"
    }
    
    init(interactor: ToDoListInteractorInput) {
        self.interactor = interactor
    }
    
    func toggleTask(_ task: ToDoTask) {
        guard let index = tasks.firstIndex(
            where: { $0.id == task.id }
        ) else {
            return
        }
        
        tasks[index].isCompleted.toggle()
    }
    
    func deleteTasks(at offsets: IndexSet, from displayedTasks: [ToDoTask]) {
        let idsToDelete = offsets.map { index in
            displayedTasks[index].id
        }
        
        tasks.removeAll { task in
            idsToDelete.contains(task.id)
        }
    }
    
    func addTask(title: String) {
        let task = ToDoTask(
            title: title,
            isCompleted: false
        )
        
        tasks.insert(task, at: 0)
    }
    
    func updateTask(id: UUID, title: String) {
        guard let index = tasks.firstIndex(
            where: { $0.id == id }
        ) else {
            return
        }
        
        tasks[index] = ToDoTask(
            id: id,
            title: title,
            isCompleted: tasks[index].isCompleted
        )
    }
}
