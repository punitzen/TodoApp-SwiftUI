//
//  SetReminderViewModelTests.swift
//  TodoApp
//
//  Created by Punit Kumar on 07/03/26.
//


import XCTest
import Combine
@testable import TodoApp

final class MockSetReminderViewModel: SetReminderViewModelProtocol {
    var selectedDate: Date = Date()
    var dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func setReminder(for todo: Todo) {
        dataManager.setReminder(for: todo, with: selectedDate)
    }
}

class SetReminderViewModelTests: XCTestCase {
    var viewModel: SetReminderViewModelProtocol!
    var mockDataManager: DataManager!
    
    override func setUpWithError() throws {
        mockDataManager = MockDataManager()
        viewModel = MockSetReminderViewModel(dataManager: mockDataManager)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockDataManager = nil
    }
    
    func testSetReminder() throws {
        let todo = Todo(title: "Test Task", note: "Test Note")
        let reminderDate = Date().addingTimeInterval(1)
        viewModel.selectedDate = reminderDate
        
        viewModel.dataManager.add(todo: todo)
        viewModel.setReminder(for: todo)
        
        let updatedTodo = viewModel.dataManager.fetchTodoList().first { $0.id == todo.id }
        XCTAssertNotNil(updatedTodo)
        XCTAssertTrue(updatedTodo?.isAlarmSet ?? false)
    }
    
    func testSetReminderUpdatesDate() throws {
        let todo = Todo(title: "Test Task", note: "Test Note")
        let reminderDate = Date().addingTimeInterval(7200)
        viewModel.selectedDate = reminderDate
        
        viewModel.dataManager.add(todo: todo)
        viewModel.setReminder(for: todo)
        
        let updatedTodo = viewModel.dataManager.fetchTodoList().first { $0.id == todo.id }
        XCTAssertEqual(updatedTodo!.date.timeIntervalSince1970, reminderDate.timeIntervalSince1970, accuracy: 1.0)
    }
    
    func testSelectedDateInitialization() throws {
        XCTAssertNotNil(viewModel.selectedDate)
        XCTAssertEqual(viewModel.selectedDate.timeIntervalSince1970, Date().timeIntervalSince1970, accuracy: 1.0)
    }
}
