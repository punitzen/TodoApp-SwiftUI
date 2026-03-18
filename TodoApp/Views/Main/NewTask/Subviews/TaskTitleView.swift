//
//  TaskTitleView.swift
//  TodoApp
//
//  Created by Punit Kumar on 10/03/2026.
//

import SwiftUI

struct TaskTitleView: View {
    @Binding var userInput: String
    @Binding var showErrorMessage: Bool
    @FocusState private var isFocused: Bool
    var shouldFocus: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Str.Main.NewTask.taskTitle)
                .multilineTextAlignment(.leading)
                .font(.setFont(size: 15, weight: .medium))
                .foregroundColor(Color.primary)

            TextField("", text: $userInput)
                .focused($isFocused)
                .font(.setFont(size: 17, weight: .regular))
                .padding(.horizontal, 10)
                .frame(height: 60)
                .background(Color.gray.opacity(0.4).cornerRadius(8))
               

            if showErrorMessage {
                Text(Str.Main.NewTask.taskTitleEmpty)
                    .multilineTextAlignment(.leading)
                    .font(.setFont(size: 12, weight: .regular))
                    .foregroundColor(Color.red)
            }
        }
        .onChange(of: shouldFocus) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isFocused = true
                }
            }
        }
    }
}


