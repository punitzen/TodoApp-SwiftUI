//
//  NewTaskView.swift
//  TodoApp
//
//  Created by Punit Kumar on 09/03/2026.
//

import SwiftUI

struct NewTaskView: View {
    @Binding var showNewTaskView: Bool
    var viewModel: NewTaskViewModel
    
    @StateObject private var textFieldManager = TextFieldManager(characterLimit: 50)
    @StateObject private var noteTextFieldManager = TextFieldManager(characterLimit: 80)
    @StateObject private var keyboard = KeyboardResponder()

    @State private var showTaskTitleErrorMessage: Bool = false
    @State private var toggleViewSwitch = false
    @State private var showReminderErrorMessage: Bool = false
    @State private var reminderDate: Date = Date()

    var canCreateTask: Bool {
        !(showTaskTitleErrorMessage || showReminderErrorMessage)
    }
    
    var shouldShowSetReminderLaterText: Bool {
        return UserDefaultsUtility.getSetReminderLaterCount() <= 3
    }

    var body: some View {
        ZStack {
            BottomSheetBaseView(toggleSheetView: $showNewTaskView) {
                VStack {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 10)

                    VStack(alignment: .leading, spacing: 20) {
                        TaskTitleView(
                            userInput: $textFieldManager.userInput,
                            showErrorMessage: $showTaskTitleErrorMessage,
                            shouldFocus: showNewTaskView
                        )
                        
                        TaskNoteView(userInput: $noteTextFieldManager.userInput)
                        
                        if keyboard.keyboardHeight <= 0 {
                            Toggle(Str.Main.NewTask.reminderSet, isOn: $toggleViewSwitch)
                                .font(.setFont(size: 15, weight: .medium))
                            
                            if toggleViewSwitch {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(Str.Main.SetReminder.selectTime)
                                            .font(.setFont(size: 13, weight: .medium))
                                            .foregroundColor(Color.primary)
                                        
                                        Spacer()
                                        
                                        DatePicker("", selection: $reminderDate, in: reminderDate..., displayedComponents: [.hourAndMinute])
                                    }
                                    
                                    if showReminderErrorMessage {
                                        Text(Str.Main.SetReminder.lateDateSelected)
                                            .multilineTextAlignment(.leading)
                                            .font(.setFont(size: 12, weight: .regular))
                                            .foregroundColor(Color.red)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 20)

                    if keyboard.keyboardHeight <= 0 {
                        VStack(spacing: 12) {
                            ActionCTAView(title: Str.Main.NewTask.createTask) {
                                createTask()
                            }
                            
                            if shouldShowSetReminderLaterText {
                                Text(Str.Main.NewTask.setReminderLater)
                                    .font(.setFont(size: 9, weight: .medium))
                                    .foregroundColor(Color.primary.opacity(0.6))
                                    .padding(.horizontal, 20)
                            }
                        }
                    }

                    Rectangle()
                        .fill(.clear)
                        .frame(
                            height:
                                (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) +
                                (UIDevice.current.hasNotch ? 0 : 10) +
                                (keyboard.keyboardHeight/1.2) +
                                ((keyboard.keyboardHeight > 0) ? 10 : 0)
                        )
                }
            } didTapBackground: {
                if keyboard.keyboardHeight > 0 {
                    UIApplication.shared.resignResponder()
                } else {
                    showNewTaskView = false
                }
            } didTapContent: {
                UIApplication.shared.resignResponder()
            }
        }
        .animation(.easeOut(duration: 0.25), value: keyboard.keyboardHeight)
        .onChange(of: showNewTaskView) { newValue in
            UIApplication.shared.resignResponder()
            
            if newValue {
                   textFieldManager.userInput = ""
                   noteTextFieldManager.userInput = ""
                   UITextView.appearance().backgroundColor = .clear
                   UITableView.appearance().backgroundColor = .clear
                   showTaskTitleErrorMessage = false
                   toggleViewSwitch = false
                   UserDefaultsUtility.increaseSetReminderLaterCount()
                   
                  
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                       UIApplication.shared.becomeFirstResponder()
                   }
               }
        }
        .onChange(of: toggleViewSwitch) { newValue in
            if newValue {
                reminderDate = Date()
                showReminderErrorMessage = false
            }
        }
    }

    func createTask() {
        let title = textFieldManager.userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let note = noteTextFieldManager.userInput.trimmingCharacters(in: .whitespacesAndNewlines)

        showTaskTitleErrorMessage = title.isEmpty
        showReminderErrorMessage = toggleViewSwitch && reminderDate <= Date()

        if canCreateTask {
            let todo = Todo(title: title, note: note, sideBarColor: Color.random)
            viewModel.addNewTask(todo: todo)
            if toggleViewSwitch { viewModel.dataManager.setReminder(for: todo, with: reminderDate) }
            showNewTaskView = false
        }
    }
}
extension UIApplication {
    func becomeFirstResponder() {
        sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
    }
}
