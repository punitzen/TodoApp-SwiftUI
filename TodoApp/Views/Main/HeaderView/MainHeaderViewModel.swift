//
//  MainHeaderViewModel.swift
//  TodoApp
//
//  Created by Punit Kumar on 12/03/2026.
//

import Foundation
import Combine

protocol MainHeaderViewModelProtocol: DataManagerAutoSubscriber {
    var todosCount: Int { get set }
    var completedTodosCount: Int { get set }
    var mostRecentTodoWithNotification: Todo? { get set }
    func updateView()
}

extension MainHeaderViewModelProtocol {
    func dataManagerDidUpdate() {
        updateView()
    }
}

class MainHeaderViewModel: ObservableObject, MainHeaderViewModelProtocol {
    @Published var todosCount: Int = 0
    @Published var completedTodosCount: Int = 0
    @Published var mostRecentTodoWithNotification: Todo?
    
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
