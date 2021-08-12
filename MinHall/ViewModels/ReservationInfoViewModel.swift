//
//  ReservationInfoViewModel.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import Foundation
import Combine
import SwiftUI
import SwiftyUserDefaults

class ReservationInfoViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var loading: Bool = false
    
    @Published var reservationId: Int = 0
    @Published var startTime: String = ""
    @Published var endTime: String = ""
    
    @Published var seatId: String = ""
    @Published var seatCoord: CGPoint = CGPoint()
    @Published var seatAngle: Angle = Angle(degrees: 0)
    
    @Published var canceledReservation: Bool = false
    
    @Published var showCancelAlert: Bool = false
    
    var onCanceled: () -> Void = {}
    
    init() {
        loadReservationInfo()
        
        $seatId
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] id in
                guard let self = self else { return }
                
                self.seatCoord = SeatInfo.coordinates[id] ?? CGPoint()
                self.seatAngle = Angle(degrees: SeatInfo.angles[id] ?? 0)
            }
            .store(in: &cancellables)
        
        $canceledReservation
            .filter { $0 }
            .sink { [weak self] _ in
                self?.onCanceled()
            }
            .store(in: &cancellables)
    }
    
    func loadReservationInfo() {
        if let reservation = AppState.shared.reservationData.reservation, let id = reservation.id {
            self.reservationId = id
            self.startTime = reservation.startTime
            self.endTime = reservation.endTime
            self.seatId = reservation.seatId
        }
        AppState.shared.reservationData.newReservation = nil
    }
    
    func cancelReservation() {
        self.loading = true
        
        Networking.shared.cancelReservation(reservationId: reservationId)
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self = self else { return }
                self.loading = false
                Defaults[\.reserved] = false
            }, receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                self.loading = false
            })
            .assign(to: \.canceledReservation, on: self)
            .store(in: &cancellables)
    }
}
