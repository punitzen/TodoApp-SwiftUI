//
//  Str.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import Foundation

struct UserDefaultKeys {
    static let setReminderLaterShownCount = "setReminderLaterShownCount"
}

struct Str {
    struct Main {
        struct Home {
            struct EmptyTask {
                static let noTasks: String = "No Tasks for now!"
                static let noTasksTodo: String = "Click + to add a new task."
            }
            
            struct Header {
                static let at = "At: "
                static let hello = "Hello"
                static let user = "User!"
                
                static func headerWithTaskCount(taskCount: Int) -> String {
                    return taskCount == 0 ? "Today you have no tasks" : "Today you have \(taskCount) tasks"
                }
                
                static func headerWithCompletedTask(taskCount: Int) -> String {
                    return "Completed: \(taskCount) Tasks"
                }
            }
        }
        
        struct NewTask {
            static let taskTitle: String = "Task title"
            static let noteDescription: String = "Task description here"
            static let createTask: String = "Create Task"
            static let timeDate: String = "Time & Date"
            static let taskTitleEmpty: String = "Task title cannot be empty!"
            static let taskNoteEmpty: String = "Write a short note about the task"
            static let lateDateSelected: String = "Please select a future date"
            static let reminderSet: String = "Need a Reminder?"
            static let setReminderLater: String = "You can also set the reminder later by clicking on todo's bell icon"
        }
        
        struct SetReminder {
            static let setReminderBtn: String = "Set Reminder"
            static let selectTime: String = "Select a time"
            static let lateDateSelected: String = "Please select a future time"
        }
        
        struct TaskView {
            static let createdAt = "Created at: "
        }
    }
}

struct Quotes {
    static let fallbackQuote: String = "Small steps today, big results tomorrow."
    
    static let quotes = [
        "Small steps today, big results tomorrow.",
        "Done is better than perfect.",
        "Progress beats procrastination.",
        "One task at a time.",
        "Future you will thank you.",
        "Start small. Finish strong.",
        "Action creates clarity.",
        "A little progress counts.",
        "Focus on the next step.",
        "Momentum starts with one task.",
        "Make today slightly better.",
        "Discipline builds freedom.",
        "Start before you're ready.",
        "Tiny tasks, big impact.",
        "Move the needle today.",
        "Consistency wins quietly.",
        "Do something your future self will appreciate.",
        "Clarity comes from doing.",
        "One checkmark closer.",
        "Great things grow daily.",
        "Your goals like action.",
        "Start now, adjust later.",
        "Energy follows action.",
        "Turn plans into progress.",
        "You got this — one task at a time.",
        "Little wins matter.",
        "Stay curious. Stay productive.",
        "A clear list, a clearer mind.",
        "Build momentum today.",
        "Make progress, not excuses."
      ]
}

struct Resources {
    struct Lottie {
        static let tick: String = "tick"
        static let confetti: String = "confetti"
    }

    struct Image {
        static let avatar: String = "photo"
        static let reminder: String = "Upcoming Reminder"
        static let bigBell: String = "bigBell"
        static let noTask: String = "noTask"
    }
}

struct Alerts {
    static let delete = "Delete"
    static let cancel = "Cancel"
    static let okay = "Okay"
    
    struct DeleteReminder {
        static let title: String = "Delete Reminder?"
        static let message: String = "Are you sure you want to delete this reminder?"
    }
    
    struct ActiveReminder {
        static let message: String = "Marking a Todo with an active reminder as completed will automatically remove the reminder. Are you sure you want to mark this task as completed?"
    }
    
    struct DeleteTask {
        static let title: String = "Delete Task?"
        static let message: String = "Are you sure you want to delete this task?"
    }
}
