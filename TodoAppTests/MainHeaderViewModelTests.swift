//
//  MainHeaderViewModelTests.swift
//  TodoApp
//
//  Created by Punit Kumar on 07/03/26.
//

import XCTest
import Combine
@testable import TodoApp

final class MockMainHeaderViewModel: MainHeaderViewModelProtocol {
    var todosCount: Int = 0
    var completedTodosCount: Int = 0
    var mostRecentTodoWithNotification: Todo?
    
    var dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        subscribe()
        updateView()
    }
    
    func updateView() {
        todosCount = dataManager.todosCount
        completedTodosCount = dataManager.completedTodosCount
        mostRecentTodoWithNotification = dataManager.mostRecentTodoWithNotification
    }
}

class MainHeaderViewModelTests: XCTestCase {
    var viewModel: MainHeaderViewModelProtocol!
    var mockDataManager: DataManager!
    
    override func setUpWithError() throws {
        mockDataManager = MockDataManager()
        viewModel = MockMainHeaderViewModel(dataManager: mockDataManager)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockDataManager = nil
    }
    
    func testUpdateView() throws {
        viewModel.updateView()
        
        XCTAssertEqual(viewModel.todosCount, mockDataManager.todosCount)
        XCTAssertEqual(viewModel.completedTodosCount, mockDataManager.completedTodosCount)
        XCTAssertEqual(viewModel.mostRecentTodoWithNotification?.id, mockDataManager.mostRecentTodoWithNotification?.id)
    }
    
    func testTodayTasksCount() throws {
        let todo = Todo(title: "Test Task", note: "Test Note")
        viewModel.dataManager.add(todo: todo)
        XCTAssertEqual(viewModel.todosCount, mockDataManager.todosCount)
    }
    
    func testCompletedTasksCount() throws {
        let todo = Todo(title: "Test Task", note: "Test Note")
        let initialCompletedCount = viewModel.dataManager.completedTodosCount
        viewModel.dataManager.add(todo: todo)
        viewModel.dataManager.toggleIsCompleted(for: todo)
        XCTAssertEqual(viewModel.completedTodosCount, initialCompletedCount+1)
    }
    
    func testMostRecentTodoWithNotification() throws {
        let todo = Todo(title: "Test Task", note: "Test Note")
        viewModel.dataManager.setReminder(for: todo, with: Date().addingTimeInterval(1))
        XCTAssertNotNil(viewModel.mostRecentTodoWithNotification)
        XCTAssertTrue(viewModel.mostRecentTodoWithNotification?.isAlarmSet ?? false)
    }
    
    func testDataManagerDidUpdateTriggersViewUpdate() throws {
        let todo = Todo(title: "Test Task", note: "Test Note")
        viewModel.dataManager.add(todo: todo)
        XCTAssertEqual(viewModel.todosCount, mockDataManager.todosCount)
    }
    
    func testViewModelInitialization() throws {
        XCTAssertNotNil(viewModel.dataManager)
        XCTAssertEqual(viewModel.todosCount, mockDataManager.todosCount)
        XCTAssertEqual(viewModel.completedTodosCount, mockDataManager.completedTodosCount)
    }
}
