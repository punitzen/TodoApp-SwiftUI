//
//  MainHeaderView.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import SwiftUI

struct MainHeaderView: View {
    @ObservedObject var viewModel: MainHeaderViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(.clear)
                .frame(height: (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 10)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(Str.Main.Home.Header.hello + " " + Str.Main.Home.Header.user)
                        .foregroundColor(.white)
                        .font(.setFont(size: 20, weight: .bold))
                    
                    Text(Str.Main.Home.Header.headerWithTaskCount(taskCount: viewModel.todosCount))
                        .foregroundColor(.white)
                        .font(.setFont(size: 14, weight: .regular))
                    
                    if viewModel.todosCount == 0 {
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 4)
                        
                        Text(Quotes.quotes.randomElement() ?? Quotes.fallbackQuote)
                            .foregroundColor(.white)
                            .font(.setFont(size: 12, weight: .medium))
                    }
                    
                    if viewModel.completedTodosCount > 0 {
                        Text(Str.Main.Home.Header.headerWithCompletedTask(taskCount: viewModel.completedTodosCount))
                            .foregroundColor(.white)
                            .font(.setFont(size: 14, weight: .regular))
                    }
                }

                Spacer()
                
                Image(Resources.Image.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            
            Rectangle()
                .fill(.clear)
                .frame(height: viewModel.mostRecentTodoWithNotification != nil ? 30 : 20)

            if viewModel.mostRecentTodoWithNotification != nil {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Resources.Image.reminder)
                            .foregroundColor(.white)
                            .font(.setFont(size: 16, weight: .bold))

                        Text(viewModel.mostRecentTodoWithNotification?.title ?? "")
                            .foregroundColor(.white)
                            .font(.setFont(size: 18, weight: .medium))

                        Text(Str.Main.Home.Header.at + (viewModel.mostRecentTodoWithNotification?.reminderTime ?? ""))
                            .foregroundColor(.white)
                            .font(.setFont(size: 12))
                    }
                    .frame(alignment: .leading)
                    .padding(10)

                    Spacer()

                    Image(Resources.Image.bigBell)
                        .frame(alignment: .trailing)
                        .padding(10)
                }
                .background(Color.reminderViewBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
                
                Rectangle()
                    .fill(.clear)
                    .frame(height: 20)
            }
        }
        .background(
            LinearGradient(colors: [Color.todoHeaderGradientSecondColor, Color.todoHeaderGradientSecondColor], startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        )
        .onAppear {
            viewModel.updateView()
        }
    }
}
