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
    
    @Published var hasReservation: Bool = false
    
    @Published var loading = false
    
    private init() {
        $reservationData
            .map { $0.reservation.id != nil }
            .removeDuplicates()
            .assign(to: \.hasReservation, on: self)
            .store(in: &cancellables)
        
        if system.accessToken != nil {
            self.loading = true
            
            Networking.shared.getMyReservation()
                .handleEvents(receiveCompletion: { [weak self] _ in
                    self?.loading = false
                })
                .receive(on: RunLoop.main)
                .sink { [weak self] reservation in
                    self?.loading = false
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
        var reservation: Reservation = Reservation()
        var newReservation: Reservation = Reservation()
        
        mutating func setStartTime(time: String) {
            newReservation.startTime = time
        }
        
        mutating func setEndTime(time: String) {
            if reservation.id != nil, newReservation.id == nil {
                newReservation = reservation
                newReservation.id = nil
                newReservation.endTime = time
            } else {
                newReservation.endTime = time
            }
        }
        
        mutating func setSeadId(id: String?) {
            newReservation.seatId = id ?? ""
        }
    }
}
