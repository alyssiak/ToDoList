//
//  TaskListView.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 02.07.2026.
//

import SwiftUI

struct ToDoTask: Identifiable {
    let id = UUID()
    let title: String
    var isCompleted: Bool
}

struct TaskListView: View {
    @State private var tasks = [
        ToDoTask(title: "Изучить основы SwiftUI", isCompleted: false),
        ToDoTask(title: "Обновить README", isCompleted: true),
        ToDoTask(title: "Сделать иконку", isCompleted: false),

    ]
    
    @State private var isShowingAddTask = false
    
    var body: some View {
        NavigationStack {
            //list создает интерфейс для каждого
            List {
                ForEach(tasks) { task in
                TaskRowView(task: task) {
                    toggleTask(task)
                }
            }
            .onDelete(perform: deleteTasks)
        }
        .navigationTitle("Список задач")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddTask = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
            //binding<bool>
        .sheet(isPresented: $isShowingAddTask) {
            AddTaskView { title in
            let newTask = ToDoTask(
                title: title,
                isCompleted: false
            )
                tasks.insert(newTask, at: 0)
            }
        }
    }
}
    
    private func toggleTask(_ task: ToDoTask) {
        guard let index = tasks.firstIndex(
            where: { $0.id == task.id }
        ) else {
            return
        }
        
        tasks[index].isCompleted.toggle()
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    TaskListView()
}
