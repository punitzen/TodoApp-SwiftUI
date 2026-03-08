//
//  DateScheduler.swift
//  TodoApp
//
//  Created by Punit Kumar on 05/03/26.
//

import Foundation

protocol DateSchedulingProtocol: AnyObject {
    var callback: ((Date) -> Void)? { get set }
    
    func schedule(_ date: Date)
    func schedule(_ dates: [Date])
    
    func cancel(_ date: Date)
    func cancelAll()
}

final class DateSchedulerManager {
    private var dates: [Date] = []
    private var timer: Timer?
    
    private let queue = DispatchQueue(label: "date.trigger.scheduler")
    
    var callback: ((Date) -> Void)?
    
    deinit {
        invalidateTimer()
    }
    
    init() {
        schedule(nextDayFirstSecond())
    }
    
    private func invalidateTimer() {
        DispatchQueue.main.async { [weak self] in
            self?.timer?.invalidate()
            self?.timer = nil
        }
    }
    
    private func scheduleNext() {
        invalidateTimer()
        
        guard let next = dates.first else { return }
        
        let interval = next.timeIntervalSinceNow
        
        if interval <= 0 {
            fire(date: next)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.timer = Timer.scheduledTimer(
                withTimeInterval: interval,
                repeats: false
            ) { [weak self] _ in
                self?.queue.async {
                    self?.fire(date: next)
                }
            }
        }
    }
    
    private func fire(date: Date) {
        dates.removeAll { $0 == date }
        callback?(date)
        scheduleNext()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            schedule(nextDayFirstSecond())
        }
    }
}

extension DateSchedulerManager: DateSchedulingProtocol {
    func schedule(_ date: Date) {
        queue.sync {
            let previousFirst = dates.first
            
            dates.append(date)
            dates.sort()
            
            if previousFirst != dates.first { scheduleNext() }
        }
    }
    
    func schedule(_ dates: [Date]) {
        queue.sync {
            let previousFirst = self.dates.first
            
            self.dates.append(contentsOf: dates)
            self.dates.sort()
            
            if previousFirst != self.dates.first { scheduleNext() }
        }
    }
    
    func cancel(_ date: Date) {
        queue.sync {
            let wasFirst = dates.first == date
            if let index = dates.firstIndex(of: date) { dates.remove(at: index) }
            if wasFirst { scheduleNext() }
        }
    }
    
    func cancelAll() {
        queue.sync {
            dates.removeAll()
            invalidateTimer()
        }
    }
}

extension DateSchedulerManager {
    private func nextDayFirstSecond(from date: Date = Date()) -> Date {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: date)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        return calendar.date(byAdding: .second, value: 1, to: tomorrow)!
    }
}
