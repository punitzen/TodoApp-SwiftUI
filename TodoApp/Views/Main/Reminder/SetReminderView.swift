//
//  SetReminderView.swift
//  TodoApp
//
//  Created by Punit Kumar on 05/03/26.
//

import SwiftUI

struct SetReminderView: View {
    @Binding var showSetReminderView: Bool
    @Binding var selectedTodo: Todo
    @ObservedObject var viewModel: SetReminderViewModel
    
    @State private var showErrorMessage: Bool = false

    var body: some View {
        ZStack {
            BottomSheetBaseView(toggleSheetView: $showSetReminderView) {
                VStack {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(Str.Main.SetReminder.selectTime)
                                .multilineTextAlignment(.leading)
                                .font(.setFont(size: 16, weight: .medium))
                                .foregroundColor(Color.primary)
                            
                            Spacer()
                            
                            DatePicker("", selection: $viewModel.selectedDate, in: viewModel.selectedDate..., displayedComponents: [.hourAndMinute])
                        }
                        
                        if showErrorMessage {
                            Text(Str.Main.SetReminder.lateDateSelected)
                                .multilineTextAlignment(.leading)
                                .font(.setFont(size: 12, weight: .regular))
                                .foregroundColor(Color.red)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 30)
                    
                    ActionCTAView(title: Str.Main.SetReminder.setReminderBtn) {
                        setReminder()
                    }

                    Rectangle()
                        .fill(.clear)
                        .frame(
                            height:
                                (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) +
                                (UIDevice.current.hasNotch ? 0 : 10)
                        )
                }
            } didTapBackground: {
                showSetReminderView = false
            } didTapContent: { }
        }
        .onChange(of: showSetReminderView) { newValue in
            if newValue {
                viewModel.selectedDate = Date()
                showErrorMessage = false
            }
        }
    }

    func setReminder() {
        if viewModel.selectedDate <= Date() {
            showErrorMessage = true
            viewModel.selectedDate = Date()
            return
        }
        
        viewModel.setReminder(for: selectedTodo)
        showSetReminderView = false
    }
}
