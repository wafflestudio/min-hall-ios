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
    var critical: Bool
    
    init(available: Binding<Bool> = .constant(true), critical: Bool = false) {
        self._available = available
        self.critical = critical
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                !available ? Color("Disabled") :
                    critical ? (configuration.isPressed ? Color("Pressed") : Color("Warning")) :
                    (configuration.isPressed ? Color("Pressed") : Color("Primary"))
            )
    }
}
