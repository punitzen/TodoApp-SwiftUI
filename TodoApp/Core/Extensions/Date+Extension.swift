//
//  Date+Extension.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import Foundation
import UIKit

extension Date: @retroactive Identifiable {
    public var id: Double {
        return self.timeIntervalSince1970
    }
}

extension Date {
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    func add(_ component: Calendar.Component, value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: component, value: value, to: self) ?? Date()
    }
}

enum DateFormatterPool {
    static var formatters: [String: DateFormatter] = [:]

    private static let queue = DispatchQueue(label: "formatter.pool")

    static func get(format: String, timezone: TimeZone = TimeZone.current) -> DateFormatter {
        return queue.sync {
            let code = timezone.identifier
            let identifier = format + code
            var formatter = formatters[identifier]
            if formatter == nil {
                formatter = DateFormatter()
                formatter!.dateFormat = format
                formatter!.timeZone = timezone
                let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
                formatter!.locale = enUSPOSIXLocale
                formatters[identifier] = formatter!
            }
            return formatter!
        }
    }

    static let dayMonthYearFormatter = DateFormatterPool.get(format: "dd MMM, yyyy")
    static let timeFormatter = DateFormatterPool.get(format: "hh:mm a")
}

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    func resignResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIDevice {
    var hasNotch: Bool {
        UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
    }
}
