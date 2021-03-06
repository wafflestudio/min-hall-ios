//
//  SeatSelectionViewModel.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/23.
//

import Foundation
import Combine
import SwiftUI
import SwiftyUserDefaults


class SeatSelectionViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var loading: Bool = false
    
    @Published var selectedSeat: String? = nil
    @Published var selected: Bool = false
    @Published var reloadScrollView: Bool = false
    
    @Published var seatInfos: [SeatInfo]
    
    init() {
        seatInfos = SeatInfo.coordinates.map { coord in
            SeatInfo(
                id: coord.key,
                x: coord.value.x,
                y: coord.value.y,
                status: .available,
                angle: SeatInfo.angles[coord.key] ?? 0
            )
        }
        
        $selectedSeat
            .dropFirst()
            .handleEvents(receiveOutput: { [weak self] id in
                if self?.reloadScrollView != true {
                    self?.reloadScrollView = true
                }
                AppState.shared.reservationData.setSeadId(id: id)
            })
            .map { $0 != nil }
            .assign(to: \.selected, onWeak: self)
            .store(in: &cancellables)
    }
    
    func getSeatStatus() {
        let reservation = AppState.shared.reservationData.newReservation
        let startAt = reservation.startTime
        let endAt = reservation.endTime
        
        self.loading = true
        
        Networking.shared.getSeats(startAt: startAt, endAt: endAt)
            .map(\.seats)
            .receive(on: RunLoop.main)
            .sink { [weak self] seats in
                guard let self = self else { return }
                seats.forEach { [weak self] seat in
                    var status = SeatStatus.available
                    if !seat.isAvailable { status = .disabled }
                    if seat.isReserved { status = .occupied }
                    if let idx = self?.seatInfos.firstIndex(where: { $0.id == seat.id }) {
                        self?.seatInfos[idx].status = status
                    }
                }
                
                if !self.reloadScrollView {
                    self.reloadScrollView = true
                }
                self.loading = false
            }
            .store(in: &cancellables)
    }
    
    func makeReservation() {
        let reservation = AppState.shared.reservationData.newReservation
        if reservation.validate() {
            let seatId = reservation.seatId
            let startAt = reservation.startTime
            let endAt = reservation.endTime
            
            self.loading = true
            
            Networking.shared.makeReservation(seatId: seatId, startAt: startAt, endAt: endAt)
                .receive(on: RunLoop.main)
                .handleEvents(receiveOutput: { [weak self] _ in
                    self?.loading = false
                }, receiveCompletion: { [weak self] _ in
                    self?.loading = false
                })
                .assign(to: \.reservationData.reservation, on: AppState.shared)
                .store(in: &cancellables)
        }
    }
}
