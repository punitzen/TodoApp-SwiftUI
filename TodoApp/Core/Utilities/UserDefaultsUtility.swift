//
//  UserDefaultsUtility.swift
//  TodoApp
//
//  Created by Punit Kumar on 07/03/26.
//

import Foundation

final class UserDefaultsUtility {
    static func getSetReminderLaterCount() -> Int {
        return UserDefaults.standard.integer(forKey: UserDefaultKeys.setReminderLaterShownCount)
    }
    
    static func increaseSetReminderLaterCount() {
        let count = UserDefaultsUtility.getSetReminderLaterCount()
        UserDefaults.standard.set(count + 1, forKey: UserDefaultKeys.setReminderLaterShownCount)
    }
}
