//
//  MainView.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import SwiftUI

struct MainView: View {
    @State var showNewTaskView = false
    @State var showTaskCompletionAnimation: Bool = false
    @StateObject var dataManager = TodoDataManager()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                MainHeaderView(viewModel: MainHeaderViewModel(dataManager: dataManager))

                HomeView(viewModel: TaskListViewModel(dataManager: dataManager),
                         onNewTaskTapped: {
                            showNewTaskView.toggle()
                         },
                         triggerCompletionAnimation: {
                            showTaskCompletionAnimation = true
                         })
            }
            
            NewTaskView(showNewTaskView: $showNewTaskView, viewModel: NewTaskViewModel(dataManager: dataManager))
            
            if showTaskCompletionAnimation {
                TaskCompletionAnimationView(showTaskCompletionAnimation: $showTaskCompletionAnimation)
            }
        }
        .background(Color.backgroundColor)
        .ignoresSafeArea()
        .onReceive(NotificationCenter.default.publisher(
            for: UIApplication.willEnterForegroundNotification
        )) { _ in
            appDidEnterForeground()
        }
    }
    
    func appDidEnterForeground() {
        dataManager.refreshList()
    }
}
