//
//  Todo.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import Foundation

protocol Dated: Hashable {
    var date: Date { get }
}

struct Todo: Dated {
    let id: UUID
    let title: String
    var isCompleted = false
    var isAlarmSet: Bool = false
    let note: String
    let date: Date
    let sideBarColor: String
    let reminder: Date
    
    var time: String {
        DateFormatterPool.timeFormatter.string(from: date)
    }

    var reminderTime: String {
        DateFormatterPool.timeFormatter.string(from: reminder)
    }
    
    init(id: UUID = UUID(), title: String = "", isCompleted: Bool = false, isAlarmSet: Bool = false, note: String = "", date: Date = Date(), sideBarColor: String = "", reminder: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.isAlarmSet = isAlarmSet
        self.note = note
        self.date = date
        self.sideBarColor = sideBarColor
        self.reminder = reminder
    }
}

extension Todo: Comparable {
    static func < (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id
    }
}
