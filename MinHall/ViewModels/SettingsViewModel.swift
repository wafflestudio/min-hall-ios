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
    @Published var wiFiName: String = ""
    @Published var wiFiPassword: String = ""
    
    var onLoggedOut: (() -> ())? = nil
    
    init() {
        wiFiName = Defaults[\.wiFiName]
        wiFiPassword = Defaults[\.wiFiPassword]
    }
    
    func logout() {
        (onLoggedOut ?? {})()
        AppState.shared.system = AppState.System()
        AppState.shared.reservationData = AppState.ReservationData()
        Defaults[\.accessToken] = nil
        Defaults[\.username] = nil
        Defaults[\.password] = nil
    }
}
