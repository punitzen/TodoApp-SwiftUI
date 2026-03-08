//
//  TaskListViewModelTests.swift
//  TodoApp
//
//  Created by Punit Kumar on 07/03/26.
//


import XCTest
import Combine
@testable import TodoApp

final class MockTaskListViewModel: TaskListViewModelProtocol {
    var todos: [Todo] = []
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


class TaskListViewModelTests: XCTestCase {
    var viewModel: TaskListViewModelProtocol!
    var mockDataManager: DataManager!
    
    override func setUpWithError() throws {
        mockDataManager = MockDataManager()
        viewModel = MockTaskListViewModel(dataManager: mockDataManager)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockDataManager = nil
    }
    
    func testFetchTodos() throws {
        viewModel.fetchTodos()
        XCTAssertFalse(viewModel.todos.isEmpty)
        XCTAssertEqual(viewModel.todos.count, viewModel.dataManager.fetchTodoList().count)
    }
    
    func testToggleIsCompleted() throws {
        let todo = Todo(title: "Test Task", note: "Test Note")
        let initialState = todo.isCompleted
        viewModel.dataManager.add(todo: todo)
        viewModel.toggleIsCompleted(for: todo)
        viewModel.fetchTodos()
        let updatedTodo = viewModel.todos.first { $0.id == todo.id }
        XCTAssertNotNil(updatedTodo)
        XCTAssertNotEqual(updatedTodo?.isCompleted, initialState)
    }
    
    func testRemoveReminder() throws {
        let todo = Todo(title: "Test Task", isAlarmSet: true, note: "Test Note")
        viewModel.dataManager.add(todo: todo)
        viewModel.dataManager.setReminder(for: todo, with: Date().addingTimeInterval(12))
        viewModel.removeReminder(for: todo)
        viewModel.fetchTodos()
        let updatedTodo = viewModel.todos.first { $0.id == todo.id }
        XCTAssertFalse(updatedTodo?.isAlarmSet ?? true)
    }
    
    func testDeleteTodo() throws {
        viewModel.fetchTodos()
        let todo = viewModel.todos.first!
        let initialCount = viewModel.todos.count
        
        viewModel.delete(todo: todo)
        
        XCTAssertEqual(viewModel.todos.count, initialCount - 1)
        XCTAssertFalse(viewModel.todos.contains { $0.id == todo.id })
    }
}
