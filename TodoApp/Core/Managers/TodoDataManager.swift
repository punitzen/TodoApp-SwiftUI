//
//  TodoDataManager.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import Foundation
import CoreData

final class TodoDataManager: ObservableObject {
    private let persistentManager = CoreDataPersistenceManager()
    private let notificationManager: LocalNotificationManager
    private let refreshScheduler: DateSchedulingProtocol
    private var observers = NSHashTable<AnyObject>.weakObjects()
    
    deinit {
        removeAllObservers()
    }

    init(notificationManager: LocalNotificationManager = LocalNotificationManager.shared, refreshScheduler: DateSchedulingProtocol = DateSchedulerManager()) {
        self.notificationManager = notificationManager
        self.refreshScheduler = refreshScheduler
        authorizeLocalNotification()
        setScheduleForRefresh()
    }

    private func authorizeLocalNotification() {
        notificationManager.requestAuthorization { error in
            print("Authorization result: \(String(describing: error))")
        }
    }
    
    private func setScheduleForRefresh() {
        refreshScheduler.callback = { [weak self] _ in
            self?.refreshList()
        }
    }
    
    private func fetchTodosCount() -> Int {
        let request: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()
        do {
            return try persistentManager.context.count(for: request)
        } catch {
            return 0
        }
    }

    private func getTodoMO(for todo: Todo) -> TodoMO? {
        let predicate = NSPredicate(format: "uuid = %@", todo.id as CVarArg)
        let result = persistentManager.fetchFirst(TodoMO.self, predicate: predicate)
        switch result {
        case .success(let todoMO):
            return todoMO
        case .failure(_):
            return nil
        }
    }
    
    private func sortTodos(_ todos: [Todo]) -> [Todo] {
        todos.sorted { a, b in
            if a.isCompleted != b.isCompleted {
                return !a.isCompleted && b.isCompleted
            }
            return a > b
        }
    }
    
    private func updatedTodoMOs(_ todoMOs: [TodoMO]) -> [Todo] {
        var todos: [Todo] = []
        
        for todoMO in todoMOs {
            var todo: Todo = todoMO.todoModel()
            if !(todoMO.date?.isToday ?? false) {
                delete(todo: todo)
            } else {
                if (todoMO.isAlarmSet && (todoMO.reminder ?? Date()) <= Date()) {
                    todoMO.isAlarmSet = false
                    todo.isAlarmSet = false
                    persistentManager.update(todoMO)
                }
                todos.append(todo)
            }
        }
        
        return sortTodos(todos)
    }
    
    private func notifyObservers() {
        for observer in observers.allObjects {
            (observer as? DataManagerObserver)?.dataManagerDidUpdate()
        }
    }
    
    private func removeAllObservers() {
        observers.removeAllObjects()
    }
    
    private func scheduleNotification(todo: Todo, with date: Date, _ completion: @escaping (_ success: Bool) -> Void) {
        let notificationData = LocationNotificationData(
            title: todo.title,
            body: todo.note,
            date: todo.date,
            reminderDate: date,
            medaData: LocationNotificationData.MetaData(id: todo.id.uuidString)
        )
        notificationManager.schedule(data: notificationData, completion)
    }

    private func cancelSchedule(for todo: Todo, handler: (([String]?, Error?) -> Void)? = nil) {
        notificationManager.cancelNotification(id: todo.id.uuidString, handler: handler)
    }
}

extension TodoDataManager: DataManager {
    var completedTodosCount: Int {
        var list = fetchTodoList()
        list = list.filter { $0.isCompleted }
        return list.count
    }
    
    var todosCount: Int {
        return fetchTodosCount()
    }
    
    var mostRecentTodoWithNotification: Todo? {
        fetchTodoList()
            .filter { $0.isAlarmSet }
            .min { $0.reminder < $1.reminder }
    }
    
    func addObserver(_ observer: any DataManagerObserver) {
        observers.add(observer)
    }
    
    func removeObserver(_ observer: any DataManagerObserver) {
        observers.remove(observer)
    }
    
    @discardableResult
    func fetchTodoList() -> [Todo] {
        let result: Result<[TodoMO], Error> = persistentManager.fetch(TodoMO.self, predicate: nil)
        switch result {
        case .success(let todoMO):
            return updatedTodoMOs(todoMO)
        case .failure(_):
            return []
        }
    }
    
    func refreshList() {
        DispatchQueue.main.async { [weak self] in
            self?.fetchTodoList()
            self?.notifyObservers()
        }
    }

    func add(todo: Todo) {
        let entity = NSEntityDescription.entity(forEntityName: "TodoMO", in: persistentManager.context)!
        let newTodo = TodoMO(entity: entity, insertInto: persistentManager.context)
        newTodo.uuid = todo.id
        newTodo.title = todo.title
        newTodo.isCompleted = false
        newTodo.isAlarmSet = false
        newTodo.note = todo.note
        newTodo.date = todo.date
        newTodo.sideBarColor = todo.sideBarColor
        newTodo.reminder = todo.reminder
        persistentManager.create(newTodo)
        DispatchQueue.main.async { [weak self] in
            self?.notifyObservers()
        }
    }

    func toggleIsCompleted(for todo: Todo) {
        guard let todoMO = getTodoMO(for: todo) else { return }
        todoMO.isCompleted.toggle()
        persistentManager.update(todoMO)
        DispatchQueue.main.async { [weak self] in
            self?.notifyObservers()
        }
    }

    func setReminder(for todo: Todo, with date: Date) {
        guard let todoMO = getTodoMO(for: todo), !todo.isAlarmSet else { return }
        
        scheduleNotification(todo: todo, with: date) { [weak self] success in
            guard let self, success else { return }
            
            todoMO.reminder = date
            todoMO.isAlarmSet.toggle()
            refreshScheduler.schedule(date)
            persistentManager.update(todoMO)
            DispatchQueue.main.async { [weak self] in
                self?.notifyObservers()
            }
        }
    }
    
    func removeReminder(for todo: Todo) {
        guard let todoMO = getTodoMO(for: todo), todo.isAlarmSet else { return }
        
        cancelSchedule(for: todo) { [weak self] _, _ in
            guard let self else { return }
            
            todoMO.isAlarmSet.toggle()
            persistentManager.update(todoMO)
            DispatchQueue.main.async { [weak self] in
                self?.notifyObservers()
            }
        }
    }
    
    func delete(todo: Todo) {
        guard let todoMO = getTodoMO(for: todo) else { return }

        if todoMO.isAlarmSet { cancelSchedule(for: todo); refreshScheduler.cancel(todo.reminder) }
        persistentManager.delete(todoMO)
        DispatchQueue.main.async { [weak self] in
            self?.notifyObservers()
        }
    }
}
