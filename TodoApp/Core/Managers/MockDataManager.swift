//
//  MockDataManager.swift
//  TodoApp
//
//  Created by Punit Kumar on 06/03/2026.
//

import Foundation
import Combine

class MockDataManager: DataManager {
    var todos = [Todo]()
    private var observers = NSHashTable<AnyObject>.weakObjects()
    
    var completedTodosCount: Int {
        todos.filter { $0.isCompleted }.count
    }
    
    var todosCount: Int {
        let calendar = Calendar.current
        return todos.filter { calendar.isDateInToday($0.date) }.count
    }
    
    var mostRecentTodoWithNotification: Todo? {
        todos.filter { $0.isAlarmSet }
            .sorted { $0.date < $1.date }
            .first
    }

    init() {
        todos = [
            Todo(title: "Good day", isCompleted: false, isAlarmSet: false, note: .randomString()),
            Todo(title: "Fetch water from well", isCompleted: false, isAlarmSet: true, note: .randomString()),
            Todo(title: "Go outside", isCompleted: false, isAlarmSet: true, note: .randomString()),
            Todo(title: "Morning workout", isCompleted: false, isAlarmSet: true, note: .randomString()),
            Todo(title: "Sign documents", isCompleted: false, note: .randomString()),
            Todo(title: "Check email", isCompleted: true, isAlarmSet: true, note: .randomString()),
            Todo(title: "Call boss", isCompleted: false, note: .randomString()),
            Todo(title: "Buy groceries", isCompleted: false, note: .randomString()),
            Todo(title: "Finish article", isCompleted: true, note: .randomString()),
            Todo(title: "Blog night", isCompleted: true, note: .randomString()),
            Todo(title: "Pay bills", isCompleted: true, note: .randomString()),
            Todo(title: "Bring the men", isCompleted: true, note: .randomString()),
        ]
    }

    func fetchTodoList() -> [Todo] {
        todos
    }

    func add(todo: Todo) {
        todos.append(todo)
        notifyObservers()
    }

    func toggleIsCompleted(for todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].isCompleted.toggle()
            notifyObservers()
        }
    }

    func setReminder(for todo: Todo, with date: Date) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            var updatedTodo = todos[index]
            updatedTodo.isAlarmSet = true
            todos[index] = Todo(
                id: todo.id,
                title: updatedTodo.title,
                isCompleted: updatedTodo.isCompleted,
                isAlarmSet: true,
                note: updatedTodo.note,
                date: date
            )
            notifyObservers()
        }
    }
    
    func removeReminder(for todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].isAlarmSet = false
            notifyObservers()
        }
    }
    
    func delete(todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos.remove(at: index)
            notifyObservers()
        }
    }
    
    func refreshList() {
        notifyObservers()
    }
    
    func addObserver(_ observer: any DataManagerObserver) {
        observers.add(observer as AnyObject)
    }
    
    func removeObserver(_ observer: any DataManagerObserver) {
        observers.remove(observer as AnyObject)
    }
    
    private func notifyObservers() {
        observers.allObjects.forEach { object in
            if let observer = object as? DataManagerObserver {
                observer.dataManagerDidUpdate()
            }
        }
    }
}

extension String {
    static func randomString(length: Int = .random(in: 5...8)) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
