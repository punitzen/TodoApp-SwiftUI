//
//  TaskListViewModel.swift
//  TodoApp
//
//  Created by Punit Kumar on 13/03/2026.
//

import SwiftUI
import Combine

protocol TaskListViewModelProtocol: DataManagerAutoSubscriber {
    var todos: [Todo] { get set }
    func fetchTodos()
    func toggleIsCompleted(for todo: Todo)
    func removeReminder(for todo: Todo?)
    func delete(todo: Todo)
}

extension TaskListViewModelProtocol {
    func dataManagerDidUpdate() {
        fetchTodos()
    }
}

final class TaskListViewModel: ObservableObject, TaskListViewModelProtocol {
    @Published var todos: [Todo] = []
    var dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        subscribe()
        fetchTodos()
    }

    func fetchTodos() {
        todos = dataManager.fetchTodoList()
    }

    func toggleIsCompleted(for todo: Todo) {
        dataManager.toggleIsCompleted(for: todo)
    }
    
    func removeReminder(for todo: Todo?) {
        guard let todo else { return }
        dataManager.removeReminder(for: todo)
    }
    
    func delete(todo: Todo) {
        dataManager.delete(todo: todo)
    }
}
