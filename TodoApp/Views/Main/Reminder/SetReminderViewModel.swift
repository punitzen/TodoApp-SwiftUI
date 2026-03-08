//
//  SetReminderViewModel.swift
//  TodoApp
//
//  Created by Punit Kumar on 05/03/26.
//

import Combine
import Foundation

protocol SetReminderViewModelProtocol: DataManagerAutoSubscriber {
    var selectedDate: Date { get set }
    func setReminder(for todo: Todo)
}

extension SetReminderViewModelProtocol {
    func dataManagerDidUpdate() { }
}

final class SetReminderViewModel: ObservableObject, SetReminderViewModelProtocol {
    @Published var selectedDate: Date = Date()
    var dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func setReminder(for todo: Todo) {
        dataManager.setReminder(for: todo, with: selectedDate)
    }
}
