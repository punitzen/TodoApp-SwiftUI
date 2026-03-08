//
//  HomeView.swift
//  TodoApp
//
//  Created by Punit Kumar on 05/03/2026.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: TaskListViewModel
    var onNewTaskTapped: (() -> Void)?
    var triggerCompletionAnimation: (() -> Void)?

    var body: some View {
        GeometryReader { geometry in
            Group {
                if viewModel.todos.isEmpty {
                    NoTaskView(onNewTaskTapped: onNewTaskTapped)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    TaskListView(viewModel: viewModel, onNewTaskTapped: onNewTaskTapped, triggerCompletionAnimation: triggerCompletionAnimation)
                }
            }
        }
    }
}
