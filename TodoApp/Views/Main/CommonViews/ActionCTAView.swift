//
//  ButtonView.swift
//  TodoApp
//
//  Created by Punit Kumar on 06/03/26.
//

import SwiftUI

struct ActionCTAView: View {
    var title: String = ""
    var titleColor: Color = .white
    var titleFont: Font = .setFont(size: 16, weight: .medium)
    
    var cornerRadius: CGFloat = 10
    var ctaColor: Color = Color.addTaskButtonColor.opacity(0.9)
    var size: CGSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 50)
    
    var action: () -> Void
    private let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        Button {
            generator.notificationOccurred(.success)
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(ctaColor)
                    
                Text(title)
                    .font(titleFont)
                    .foregroundColor(titleColor)
            }
            .frame(width: size.width, height: size.height)
        }
    }
}
