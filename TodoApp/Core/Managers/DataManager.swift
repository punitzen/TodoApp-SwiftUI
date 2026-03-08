//
//  DataManager.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import Foundation

protocol DataManagerObserver: AnyObject {
    func dataManagerDidUpdate()
}

protocol DataManagerAutoSubscriber: DataManagerObserver {
    var dataManager: DataManager { get set }
}

extension DataManagerAutoSubscriber {
    func subscribe() {
        dataManager.addObserver(self)
    }
}

protocol DataManager {
    var todosCount: Int { get }
    var completedTodosCount: Int { get }
    var mostRecentTodoWithNotification: Todo? { get }
    
    func fetchTodoList() -> [Todo]
    func refreshList()
    
    func setReminder(for todo: Todo, with date: Date)
    func toggleIsCompleted(for todo: Todo)
    func removeReminder(for todo: Todo)
    
    func add(todo: Todo)
    func delete(todo: Todo)
    
    func addObserver(_ observer: DataManagerObserver)
    func removeObserver(_ observer: DataManagerObserver)
}
