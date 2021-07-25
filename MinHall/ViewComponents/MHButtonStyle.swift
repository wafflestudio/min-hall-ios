//
//  MHButtonStyle.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/25.
//

import Foundation
import SwiftUI

struct MHButtonStyle: ButtonStyle {
    @Binding var available: Bool
    
    init(available: Binding<Bool> = .constant(true)) {
        self._available = available
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(!available ? Color("Disabled") : (configuration.isPressed ? Color("Pressed") : Color("Primary")))
    }
}
