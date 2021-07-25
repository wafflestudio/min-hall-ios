//
//  SeatSelectionViewModel.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/23.
//

import Foundation
import Combine
import SwiftUI


class SeatSelectionViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var selectedSeat: Int = -1
    @Published var selected: Bool = false
    @Published var reloadScrollView: Bool = false
    
    var onReserved: () -> Void = {}
    
    @Published var seatInfos = [
        SeatInfo(id: 1, x: 313.5, y: 211.5, status: .available, angle: Angle(degrees: -30.3)),
        SeatInfo(id: 2, x: 259.5, y: 242.5, status: .available, angle: Angle(degrees: -30.3)),
        SeatInfo(id: 3, x: 572.5, y: 62.5, status: .available),
        SeatInfo(id: 4, x: 663.5, y: 62.5, status: .available),
        SeatInfo(id: 5, x: 482.5, y: 62.5, status: .available),
        SeatInfo(id: 6, x: 744.5, y: 155, status: .available),
        SeatInfo(id: 7, x: 744.5, y: 380, status: .available),
        SeatInfo(id: 8, x: 744.5, y: 484, status: .available),
        SeatInfo(id: 9, x: 557.5, y: 484, status: .available),
        SeatInfo(id: 10, x: 497, y: 484, status: .available),
        SeatInfo(id: 11, x: 404.5, y: 351.5, status: .available),
        SeatInfo(id: 12, x: 592, y: 309, status: .available),
        SeatInfo(id: 13, x: 592, y: 248.5, status: .available),
        SeatInfo(id: 14, x: 527.5, y: 217.5, status: .available),
        SeatInfo(id: 15, x: 467, y: 217.5, status: .available),
        SeatInfo(id: 16, x: 1094, y: 124, status: .available),
        SeatInfo(id: 17, x: 1094, y: 196.5, status: .available),
        SeatInfo(id: 18, x: 1094, y: 268.5, status: .available),
        SeatInfo(id: 19, x: 1094, y: 341, status: .available),
        SeatInfo(id: 20, x: 1094, y: 415.5, status: .available),
        SeatInfo(id: 21, x: 1094, y: 487.5, status: .available),
        SeatInfo(id: 22, x: 1094, y: 560, status: .available),
        SeatInfo(id: 23, x: 1094, y: 632, status: .available),
        SeatInfo(id: 24, x: 927.5, y: 632, status: .available),
        SeatInfo(id: 25, x: 927.5, y: 560, status: .available),
        SeatInfo(id: 26, x: 927.5, y: 487.5, status: .available),
        SeatInfo(id: 27, x: 927.5, y: 415.5, status: .available),
        SeatInfo(id: 28, x: 927.5, y: 341, status: .available),
        SeatInfo(id: 29, x: 927.5, y: 268.5, status: .available),
        SeatInfo(id: 30, x: 927.5, y: 196.5, status: .available),
        SeatInfo(id: 31, x: 927.5, y: 124, status: .available),
        SeatInfo(id: 32, x: 1272.5, y: 62.5, status: .available),
        SeatInfo(id: 33, x: 1352.5, y: 62.5, status: .available),
        SeatInfo(id: 34, x: 1344.5, y: 229.5, status: .available),
        SeatInfo(id: 35, x: 1344.5, y: 354.5, status: .available),
        SeatInfo(id: 36, x: 1352.5, y: 519, status: .available),
        SeatInfo(id: 37, x: 1272.5, y: 519, status: .available),
        SeatInfo(id: 38, x: 1181.5, y: 229.5, status: .available),
        SeatInfo(id: 39, x: 1181.5, y: 354.5, status: .available),
        SeatInfo(id: 40, x: 1521.5, y: 62.5, status: .available),
        SeatInfo(id: 41, x: 1644, y: 62.5, status: .available),
        SeatInfo(id: 42, x: 1657.5, y: 229.5, status: .available),
        SeatInfo(id: 43, x: 1657.5, y: 354.5, status: .available),
        SeatInfo(id: 44, x: 1505, y: 354.5, status: .available),
        SeatInfo(id: 45, x: 1505, y: 229.5, status: .available),
        SeatInfo(id: 46, x: 1753, y: 637.5, status: .available),
        SeatInfo(id: 47, x: 1753, y: 557, status: .available),
        SeatInfo(id: 48, x: 1487, y: 611, status: .available),
        SeatInfo(id: 49, x: 1567.5, y: 611, status: .available),
        SeatInfo(id: 50, x: 1567.5, y: 758, status: .available),
        SeatInfo(id: 51, x: 1487, y: 758, status: .available),
        SeatInfo(id: 52, x: 444.5, y: 611, status: .available),
        SeatInfo(id: 53, x: 525, y: 611, status: .available),
        SeatInfo(id: 54, x: 525, y: 758, status: .available),
        SeatInfo(id: 55, x: 444.5, y: 758, status: .available),
        SeatInfo(id: 56, x: 234.5, y: 661.5, status: .available),
        SeatInfo(id: 57, x: 234.5, y: 577, status: .available),
        SeatInfo(id: 58, x: 234.5, y: 492.5, status: .available),
        SeatInfo(id: 59, x: 234.5, y: 408.5, status: .available),
        SeatInfo(id: 60, x: 62.5, y: 661.5, status: .available),
        SeatInfo(id: 61, x: 62.5, y: 577, status: .available),
        SeatInfo(id: 62, x: 62.5, y: 492.5, status: .available),
        SeatInfo(id: 63, x: 62.5, y: 408.5, status: .available),
    ]
    
    init() {
        $selectedSeat
            .dropFirst()
            .handleEvents(receiveOutput: { id in
                self.reloadScrollView = true
                AppState.shared.setSeadId(id: id)
            })
            .map { $0 != -1 }
            .assign(to: \.selected, on: self)
            .store(in: &cancellables)
    }
    
    func makeReservation() {
        let valid = AppState.shared.setReserved()
        if valid {
            // .. send request
            
            onReserved()
        }
    }
}
