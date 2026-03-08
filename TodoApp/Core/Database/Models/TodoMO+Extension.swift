//
//  TodoMO+Extension.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import Foundation

extension TodoMO {
    func todoModel() -> Todo {
        Todo(
            id: uuid ?? UUID(),
            title: title ?? "Unknown",
            isCompleted: isCompleted,
            isAlarmSet: isAlarmSet,
            note: note ?? "",
            date: date ?? Date(),
            sideBarColor: sideBarColor ?? "",
            reminder: reminder ?? Date()
        )
    }
}
