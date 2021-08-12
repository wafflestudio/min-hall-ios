//
//  SettingsViewModel.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/27.
//

import Foundation
import Combine
import SwiftyUserDefaults

class SettingsViewModel: ObservableObject {
    @Published var showLogoutAlert: Bool = false
    
    var onLoggedOut: () -> () = {}
    
    func logout() {
        AppState.shared.system.accessToken = nil
        Defaults[\.accessToken] = nil
        Defaults[\.username] = nil
        Defaults[\.password] = nil
        onLoggedOut()
    }
}
