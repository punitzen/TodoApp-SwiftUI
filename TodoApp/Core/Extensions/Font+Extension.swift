//
//  Font+Extension.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import SwiftUI

extension Font {
    static func setFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        system(size: size, weight: weight)
    }
}
