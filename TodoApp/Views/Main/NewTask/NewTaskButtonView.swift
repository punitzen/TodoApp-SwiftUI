//
//  NewTaskButtonView.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/26.
//

import SwiftUI

struct NewTaskButtonView: View {
    var size: CGFloat = 50
    var didTap: () -> Void
    private let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        Button {
            generator.notificationOccurred(.success)
            didTap()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(Color.white)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.addTaskButtonColor)
            }
            .frame(width: size, height: size)
            .shadow(color: Color.addTaskButtonColor.opacity(0.24), radius: 5, x: 0, y: 7)
        }
    }
}
