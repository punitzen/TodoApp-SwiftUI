//
//  TaskNoteView.swift
//  TodoApp
//
//  Created by Punit Kumar on 10/03/2026.
//

import SwiftUI

struct TaskNoteView: View {
    @Binding var userInput: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Str.Main.NewTask.noteDescription)
                .multilineTextAlignment(.leading)
                .font(.setFont(size: 15, weight: .medium))
                .foregroundColor(.primary)

            TextEditor(text: $userInput)
                .font(.setFont(size: 17))
                .padding(.horizontal, 10)
                .background(Color.gray.opacity(0.4).cornerRadius(8))
                .frame(height: 100)
                .foregroundColor(.primary)
                .scrollContentBackground(.hidden)
        }
    }
}
