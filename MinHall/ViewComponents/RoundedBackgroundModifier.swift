//
//  RoundedBackgroundModifier.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import Foundation
import SwiftUI

extension View {
    func roundedBackground() -> some View {
        return self.modifier(RoundedBackgroundModifier())
    }
}

struct RoundedBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill()
                    .foregroundColor(.white)
            )
    }
}
