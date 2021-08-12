//
//  AppState.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import Foundation
import Combine
import SwiftyUserDefaults

class AppState: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = AppState()
    
    @Published var system = System()

    @Published var reservationData = ReservationData()
    
    private init() {
        if system.accessToken != nil {
            Networking.shared.getMyReservation()
                .receive(on: RunLoop.main)
                .sink { reservation in
                    AppState.shared.reservationData.reservation = reservation
                }
                .store(in: &cancellables)
        }
    }
}

extension AppState {
    struct System {
        var error: Bool = false
        var errorMessage: String? = nil
        var accessToken: String?
        
        init() {
            self.accessToken = Defaults[\.accessToken]
        }
    }
    
    struct ReservationData {
        var reservation: Reservation? = nil
        var newReservation: Reservation? = nil
        
        mutating func setStartTime(time: String) {
            if newReservation != nil {
                newReservation?.startTime = time
            } else {
                newReservation = Reservation()
                newReservation?.startTime = time
            }
        }
        
        mutating func setEndTime(time: String) {
            if reservation != nil, newReservation == nil {
                newReservation = reservation
                newReservation?.id = nil
                newReservation?.endTime = time
            } else if newReservation == nil {
                newReservation = Reservation()
                newReservation?.endTime = time
            } else {
                newReservation?.endTime = time
            }
        }
        
        mutating func setSeadId(id: String?) {
            newReservation?.seatId = id ?? ""
        }
    }
}
