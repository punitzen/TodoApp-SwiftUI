//
//  BottomSheetBaseView.swift
//  TodoApp
//
//  Created by Punit Kumar on 06/03/26.
//

import SwiftUI

struct BottomSheetBaseView<Content: View>: View {
    @Binding var toggleSheetView: Bool
    var contentView: () -> Content
    var didTapBackground: () -> Void
    var didTapContent: () -> Void
    
    @State private var yOffset: CGFloat = 2000
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .opacity(toggleSheetView ? 1 : 0)
                .animation(.easeOut(duration: 0.1), value: toggleSheetView)
                .onTapGesture {
                    didTapBackground()
                }
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.clear)

                Spacer(minLength: 0)

                VStack(spacing: -18) {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color(.secondarySystemBackground))
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5, style: .circular)
                                .foregroundColor(.gray)
                                .frame(width: 70, height: 6)
                                .offset(y: -2)
                        )
                    
                    contentView().background(Color(.secondarySystemBackground))
                }
            }
            .offset(y: yOffset)
            .onTapGesture {
                didTapContent()
            }
        }
        .onChange(of: toggleSheetView) { newValue in
            withAnimation(.easeInOut(duration: 0.4)) {
                yOffset = newValue ? 0 : 2000
            }
        }
    }
}
