//
//  Color+Extension.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import SwiftUI

extension Color {
    static let backgroundColor = Color("backgroundColor")
    static let primaryTextColor = Color("primaryTextColor")
    static let infoColor = Color("infoColor")
    static let lightGreen = Color(hex: "91DC5A")
    static let lightYellow = Color(hex: "FFDC00")
    static let reminderViewBackgroundColor = Color("reminderViewBackgroundColor")

    static let todoGradientFirstColor = Color("todoGradientFirstColor")
    static let todoGradientSecondColor = Color("todoGradientSecondColor")
    static let todoHeaderGradientFirstColor = Color("todoHeaderGradientFirstColor")
    static let todoHeaderGradientSecondColor = Color("todoHeaderGradientSecondColor")

    static let shadowColor = Color(hex: "66C81C")
    static let addTaskButtonColor = Color(hex: "E0139C")
    static let addTaskButtonShadowColor = Color("addTaskButtonShadowColor")
    static let sectionTitleColor = Color(hex: "8B87B3")
    static let rowColor = Color("rowColor")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    private static var lastIndex: Int = 0
    
    static let colorArray: [String] = ["FFD506", "1ED102", "D10263", "3044F2", "F59BFF", "F29130", "FF6B6B", "FF8E72", "FFA69E", "FFB703", "FB8500", "E76F51", "2A9D8F", "00B4D8", "48CAE4","90E0EF","4CC9F0", "4361EE", "3A0CA3", "7209B7","B5179E","F72585", "06D6A0", "118AB2", "073B4C", "C77DFF", "9D4EDD", "7B2CBF", "80ED99", "57CC99", "38A3A5"]
    
    static var random: String {
        var newIndex: Int
        
        repeat {
            newIndex = Int.random(in: 0..<colorArray.count)
        } while newIndex == lastIndex
        
        lastIndex = newIndex
        return colorArray[newIndex]
    }
}
