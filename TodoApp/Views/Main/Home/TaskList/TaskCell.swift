//
//  TaskCell.swift
//  TodoApp
//
//  Created by Punit Kumar on 06/03/2026.
//

import SwiftUI

struct TaskCell: View {
    let todo: Todo
    var onToggleCompletedTask: (() -> Void)?
    var onToggleSetReminder: (() -> Void)?
    var onDeleteTask: (() -> Void)?
    
    @State private var showDeleteAlert = false

    var body: some View {
        ZStack {
            HStack {
                Color(hex: todo.sideBarColor)
                    .frame(width: 4)
                Spacer()
            }
            
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    VStack {
                        Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(todo.isCompleted ? .green : .gray)
                            .onTapGesture {
                                onToggleCompletedTask?()
                            }
                        
                        Spacer()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(todo.title)
                            .foregroundColor(todo.isCompleted ? .gray : .primaryTextColor)
                            .strikethrough(todo.isCompleted)
                            .font(.setFont(size: 16 , weight: .bold))

                        if !todo.note.isEmpty {
                            Text(todo.note)
                                .foregroundColor(todo.isCompleted ? .gray : Color.primaryTextColor.opacity(0.7))
                                .strikethrough(todo.isCompleted)
                                .multilineTextAlignment(.leading)
                                .font(.setFont(size: 13))
                        }
                        
                        Spacer()
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 12) {
                        if !todo.isCompleted {
                            Image(systemName: todo.isAlarmSet ? "bell.badge.fill" : "bell.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: todo.isAlarmSet ? 20 : 18, height: todo.isAlarmSet ? 22 : 20)
                                .cornerRadius(10)
                                .foregroundColor(.lightYellow.opacity(todo.isAlarmSet ? 1 : 0.5))
                                .onTapGesture {
                                    onToggleSetReminder?()
                                }
                        }
                        
                        Image(systemName: "minus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 16)
                            .cornerRadius(10)
                            .foregroundColor(.red)
                            .onTapGesture {
                                showDeleteAlert = true
                            }
                            .alert(Alerts.DeleteTask.title, isPresented: $showDeleteAlert) {
                                Button(Alerts.delete, role: .destructive) { onDeleteTask?() }
                                Button(Alerts.cancel, role: .cancel) { }
                            } message: {
                                Text(Alerts.DeleteTask.message)
                            }
                        
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Text(Str.Main.TaskView.createdAt + todo.time)
                        .foregroundColor(.infoColor)
                        .font(.setFont(size: 11))
                }
            }
            .padding(16)
        }
        .background(Color.rowColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .opacity(todo.isCompleted ? 0.5 : 1)
    }
}
