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
    
    let formatter = DateFormatter()
    private let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .default)
    
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
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "HH:mm"
        
        loadReservationInfo()
        
        timerPublisher.connect().store(in: &cancellables)
        
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
                AppState.shared.reservationData.reservation = Reservation()
                self?.onCanceled()
            }
            .store(in: &cancellables)
        
        timerPublisher
            .sink { [weak self] now in
                guard let self = self else { return }
                let nowInString = self.formatter.string(from: now)
                if nowInString > self.endTime {
                    AppState.shared.reservationData.reservation = Reservation()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadReservationInfo() {
        let reservation = AppState.shared.reservationData.reservation
        if let id = reservation.id {
            self.reservationId = id
            let sIdx = reservation.startTime.index(reservation.startTime.endIndex, offsetBy: -5)
            self.startTime = String(reservation.startTime[sIdx...])
            let eIdx = reservation.endTime.index(reservation.endTime.endIndex, offsetBy: -5)
            self.endTime = String(reservation.endTime[eIdx...])
            self.seatId = reservation.seatId
        }
        AppState.shared.reservationData.newReservation = Reservation()
    }
    
    func scheduleNotification() {
        let manager = LocalNotificationManager()
        let endTimeSplit = endTime.split(separator: ":")
        var alertHour = Int(endTimeSplit[0]) ?? 0
        var alertMinute = Int(endTimeSplit[1]) ?? 0
        
        alertMinute -= 5
        if alertMinute < 0 {
            alertMinute += 60
            alertHour -= 1
        }
        manager.scheduleNotification(title: "민상렬홀 좌석 사용", body: "좌석 사용 시간이 곧 만료됩니다.", hour: alertHour, minute: alertMinute)
    }
    
    func cancelReservation() {
        self.loading = true
        
        Networking.shared.cancelReservation(reservationId: reservationId)
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self = self else { return }
                self.loading = false
            }, receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                self.loading = false
            })
            .assign(to: \.canceledReservation, on: self)
            .store(in: &cancellables)
    }
}
