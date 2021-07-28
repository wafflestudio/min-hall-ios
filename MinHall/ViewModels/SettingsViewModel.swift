//
//  SettingsViewModel.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/27.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var showLogoutAlert: Bool = false
    
    var onLoggedOut: () -> () = {}
    
    func logout() {
        // .. Log out
        
        AppState.shared.cancelReservation()
        onLoggedOut()
    }
}
