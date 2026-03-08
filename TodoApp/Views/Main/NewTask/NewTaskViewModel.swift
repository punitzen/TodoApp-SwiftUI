//
//  NewTaskViewModel.swift
//  TodoApp
//
//  Created by Punit Kumar on 10/03/2026.
//

import Foundation

protocol NewTaskViewModelProtocol: DataManagerAutoSubscriber {
    func addNewTask(todo: Todo)
}

extension NewTaskViewModelProtocol {
    func dataManagerDidUpdate() { }
}

final class NewTaskViewModel: NewTaskViewModelProtocol {
    var dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func addNewTask(todo: Todo) {
        dataManager.add(todo: todo)
    }
}
