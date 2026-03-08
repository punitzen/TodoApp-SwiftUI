//
//  TaskListView.swift
//  TodoApp
//
//  Created by Punit Kumar on 06/03/2026.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskListViewModel
    var onNewTaskTapped: (() -> Void)?
    var triggerCompletionAnimation: (() -> Void)?
    
    @State var showSetReminderView = false
    @State var reminderTodo: Todo = .init()
    @State private var showRemoveReminderAlert = false
    @State private var showCompleteTaskAlert = false
    @State private var actionTodo: Todo?

    private let generator = UINotificationFeedbackGenerator()

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 20)
                
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                    ForEach(viewModel.todos, id: \.id) { todo in
                        TaskCell(todo: todo,
                            onToggleCompletedTask: {
                                if !todo.isAlarmSet {
                                    viewModel.toggleIsCompleted(for: todo)
                                    if !todo.isCompleted { triggerCompletionAnimation?() }
                                } else {
                                    actionTodo = todo
                                    showCompleteTaskAlert = true
                                }
                                generator.notificationOccurred(todo.isCompleted ? .error : .warning)
                            },
                            onToggleSetReminder: {
                                if !todo.isAlarmSet {
                                    reminderTodo = todo
                                    showSetReminderView.toggle()
                                } else {
                                    actionTodo = todo
                                    showRemoveReminderAlert = true
                                }
                            },
                            onDeleteTask: {
                                viewModel.delete(todo: todo)
                                generator.notificationOccurred(.success)
                            }
                        )
                    }
                }
                .padding(.horizontal, 10)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + (UIDevice.current.hasNotch ? 0 : 10) + 70)
            }
            
            if viewModel.todos.count != 0 {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NewTaskButtonView(size: 45) {
                            onNewTaskTapped?()
                        }
                    }
                    .padding(.trailing, 16)
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + (UIDevice.current.hasNotch ? 0 : 10))
                }
            }
            
            SetReminderView(showSetReminderView: $showSetReminderView, selectedTodo: $reminderTodo, viewModel: SetReminderViewModel(dataManager: viewModel.dataManager))
        }
        .onAppear {
            self.viewModel.fetchTodos()
        }
        .alert(Alerts.DeleteReminder.title, isPresented: $showRemoveReminderAlert) {
            Button(Alerts.delete, role: .destructive) { handleAlert() }
            Button(Alerts.cancel, role: .cancel) { actionTodo = nil }
        } message: {
            Text(Alerts.DeleteReminder.message)
        }
        .alert("", isPresented: $showCompleteTaskAlert) {
            Button(Alerts.okay, role: .destructive) { handleAlert(markCompleted: true) }
            Button(Alerts.cancel, role: .cancel) { actionTodo = nil }
        } message: {
            Text(Alerts.ActiveReminder.message)
        }
    }
    
    private func handleAlert(markCompleted: Bool = false) {
        guard let actionTodo else { return }
        
        viewModel.removeReminder(for: actionTodo)
        if markCompleted {
            viewModel.toggleIsCompleted(for: actionTodo)
            if !actionTodo.isCompleted { triggerCompletionAnimation?() }
        }
        generator.notificationOccurred(.success)
    }
}
