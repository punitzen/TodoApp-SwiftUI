//
//  NewTaskViewModelTests.swift
//  TodoApp
//
//  Created by Punit Kumar on 07/03/26.
//


import XCTest
@testable import TodoApp

final class MockNewTaskViewModel: NewTaskViewModelProtocol {
    var dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func addNewTask(todo: Todo) {
        dataManager.add(todo: todo)
    }
}

class NewTaskViewModelTests: XCTestCase {
    var viewModel: NewTaskViewModelProtocol!
    var mockDataManager: DataManager!
    
    override func setUpWithError() throws {
        mockDataManager = MockDataManager()
        viewModel = MockNewTaskViewModel(dataManager: mockDataManager)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockDataManager = nil
    }
    
    func testAddNewTask() throws {
        let initialCount = viewModel.dataManager.todosCount
        let newTodo = Todo(title: "New Task", note: "Test note", date: Date())
        
        viewModel.addNewTask(todo: newTodo)
        let todos = viewModel.dataManager.fetchTodoList()
        
        XCTAssertEqual(todos.count, initialCount + 1)
        XCTAssertTrue(todos.contains { $0.id == newTodo.id })
    }
}
