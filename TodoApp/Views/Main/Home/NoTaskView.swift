//
//  NoTaskView.swift
//  TodoApp
//
//  Created by Punit Kumar on 05/03/2026.
//

import SwiftUI

struct NoTaskView: View {
    var onNewTaskTapped: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 45) {
            ZStack {
                Image(Resources.Image.noTask)
                
                NewTaskButtonView(size: 45) {
                    self.onNewTaskTapped?()
                }
                .padding(.top, 20)
            }
            .onTapGesture {
                self.onNewTaskTapped?()
            }

            VStack(spacing: 6) {
                Text(Str.Main.Home.EmptyTask.noTasks)
                    .foregroundColor(.primaryTextColor)
                    .font(.setFont(size: 25, weight: .bold))

                Text(Str.Main.Home.EmptyTask.noTasksTodo)
                    .foregroundColor(.infoColor)
                    .font(.setFont(size: 17))
            }
        }
        .padding(.horizontal, 16)
    }
}
