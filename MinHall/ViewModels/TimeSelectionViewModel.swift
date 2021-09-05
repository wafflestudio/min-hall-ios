//
//  TimeSelectionViewModel.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import Foundation
import Combine
import SwiftyUserDefaults

class TimeSelectionViewModel: ObservableObject {
    enum TimeType: String {
        case start = "시작"
        case end = "완료"
    }
    
    enum ModifyType: Int {
        case increase = 1
        case decrease = -1
    }
    
    private let minimumMinuteDelta = 30
    private let minuteDelta = 30
    private let hourDelta = 1
    
    private let formatter = DateFormatter()
    private let now = Date()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var loading: Bool = false
    
    @Published var showAnnounce: Bool = false
    @Published var announceTitle: String = "공지사항"
    @Published var announceMessage: String = ""
    
    @Published var showWarning: Bool = false
    @Published var warningTitle: String = "경고"
    @Published var warningMessage: String = ""
    
    @Published var startHour: Int = 0
    @Published var startMinute: Int = 0
    
    @Published var endHour: Int = 0
    @Published var endMinute: Int = 0
    
    @Published var today: String
    
    @Published var toSeatSelect = false
    @Published var isExtend = false
    
    var onExtended: (() -> ())? = nil
    
    private var startHourLowerLimit = -1
    private var startMinuteLowerLimit = -1
    private var endHourLowerLimit = -1
    private var endMinuteLowerLimit = -1
    
    private var startHourUpperLimit = 23
    private var startMinuteUpperLimit = 00
    private var endHourUpperLimit = 23
    private var endMinuteUpperLimit = 30
    
    init() {
        LocalNotificationManager().requestPermission()
        
        formatter.locale = Locale(identifier: "ko_kr")
        
        formatter.dateFormat = "yyyy / MM / dd"
        today = formatter.string(from: now)
        
        self.fetchNotification()
        
        AppState.shared.$hasReservation
            .receive(on: RunLoop.main)
            .sink { [weak self] reserved in
                self?.setupTimes()
            }
            .store(in: &cancellables)
        
        $startHour
            .combineLatest($startMinute)
            .removeDuplicates { $0.0 == $1.0 && $0.1 == $1.1 }
            .sink { (hour, minute) in
                AppState.shared.reservationData.setStartTime(time: String(format: "%02d:%02d", hour, minute))
            }
            .store(in: &cancellables)
        
        $endHour
            .combineLatest($endMinute)
            .removeDuplicates { $0.0 == $1.0 && $0.1 == $1.1 }
            .sink { (hour, minute) in
                AppState.shared.reservationData.setEndTime(time: String(format: "%02d:%02d", hour, minute))
            }
            .store(in: &cancellables)
    }
    
    func extendReservation() {
        if let reservationId = AppState.shared.reservationData.reservation.id,
           AppState.shared.reservationData.newReservation.endTime != "" {
            let endAt = AppState.shared.reservationData.newReservation.endTime
            
            self.loading = true
            
            Networking.shared.extendReservation(reservationId: reservationId, endAt: endAt)
                .receive(on: RunLoop.main)
                .handleEvents(receiveOutput: { [weak self] _ in
                    self?.loading = false
                    (self?.onExtended ?? {})()
                }, receiveCompletion: { [weak self] _ in
                    self?.loading = false
                })
                .assign(to: \.reservationData.reservation, on: AppState.shared)
                .store(in: &cancellables)
        }
    }
    
    func fetchReservationSettings() {
        Networking.shared.getReservationSettings()
            .receive(on: RunLoop.main)
            .sink { [weak self] settings in
                guard let self = self else { return }
                
                let openTimeSplit = settings.openTime.split(separator: ":")
                let openHour = Int(openTimeSplit[0]) ?? 0
                let openMinute = Int(openTimeSplit[1]) ?? 0
                
                self.startHourLowerLimit = openHour
                self.startMinuteLowerLimit = openMinute
                self.endMinuteLowerLimit = openMinute + self.minimumMinuteDelta
                self.endHourLowerLimit = openHour + (self.endMinuteLowerLimit / 60)
                self.endMinuteLowerLimit %= 60
                
                let closeTimeSplit = settings.closeTime.split(separator: ":")
                let closeHour = Int(closeTimeSplit[0]) ?? 0
                let closeMinute = Int(closeTimeSplit[1]) ?? 0
                
                self.endHourUpperLimit = closeHour
                self.endMinuteUpperLimit = closeMinute
                self.startMinuteUpperLimit = closeMinute - self.minimumMinuteDelta
                self.startHourUpperLimit = closeHour
                if self.startMinuteUpperLimit < 0 {
                    let hDelta = (self.startMinuteUpperLimit / 60) - 1
                    self.startMinuteUpperLimit += (60 * -hDelta)
                    self.startHourUpperLimit += hDelta
                }
                
                Defaults[\.wiFiName] = settings.wiFiName
                Defaults[\.wiFiPassword] = settings.wiFiPassword
                
                self.setupTimes()
            }
            .store(in: &cancellables)
    }
    
    func fetchNotification() {
        if !AppState.shared.hasReservation {
            self.loading = true
            
            Networking.shared.getNotification()
                .zip(Networking.shared.getWarning())
                .receive(on: RunLoop.main)
                .handleEvents(receiveOutput: { [weak self] _ in
                    self?.loading = false
                }, receiveCompletion: { [weak self] _ in
                    self?.loading = false
                })
                .sink { [weak self] noti, warn in
                    let lastNotificationId = Defaults[\.lastNotificationId]
                    self?.showAnnounce = lastNotificationId < noti.version
                    self?.showWarning = warn.show
                    Defaults[\.lastNotificationId] = noti.version
                    
                    self?.announceTitle = noti.title ?? ""
                    self?.announceMessage = noti.message ?? ""
                    self?.warningTitle = warn.title ?? ""
                    self?.warningMessage = warn.message ?? ""
                }
                .store(in: &cancellables)
        }
    }
    
    func setupTimes() {
        let reservation = AppState.shared.reservationData.reservation
        
        if reservation.id != nil {
            let sIdx = reservation.startTime.index(reservation.startTime.endIndex, offsetBy: -5)
            let startTimeSplit = reservation.startTime[sIdx...].split(separator: ":")
            self.startHour = Int(startTimeSplit[0]) ?? 0
            self.startMinute = Int(startTimeSplit[1]) ?? 0
            let eIdx = reservation.endTime.index(reservation.endTime.endIndex, offsetBy: -5)
            let endTimeSplit = reservation.endTime[eIdx...].split(separator: ":")
            self.endHour = Int(endTimeSplit[0]) ?? 0
            self.endMinute = Int(endTimeSplit[1]) ?? 0
            
            self.endHourLowerLimit = self.endHour
            self.endMinuteLowerLimit = self.endMinute
            
            adjustEndUpperLimit()
            
            self.isExtend = true
        } else {
            formatter.dateFormat = "HH"
            startHour = Int(formatter.string(from: now)) ?? 0
            
            formatter.dateFormat = "mm"
            startMinute = Int(formatter.string(from: now)) ?? 0
            
            if startMinute > 30 {
                startMinute = 0
                startHour += 1
            } else if startMinute > 0 {
                startMinute = 30
            }
            
            adjustStartLowerLimit()
            adjustStartUpperLimit()

            endMinute = startMinute + 30
            endHour = startHour + (endMinute / 60)
            if endHour >= 24 {
                endHour = 24
                endMinute = 0
            } else {
                endMinute %= 60
            }
            
            adjustEndLowerLimit()
            adjustEndUpperLimit()
            
            self.isExtend = false
        }
    }
    
    func getHour(type: TimeType) -> Int {
        if type == .start {
            return startHour
        } else {
            return endHour
        }
    }
    
    func getMinute(type: TimeType) -> Int {
        if type == .start {
            return startMinute
        } else {
            return endMinute
        }
    }

    func modifyMinute(type: TimeType, modify: ModifyType) {
        if type == .start {
            changeStartMinute(by: modify.rawValue * minuteDelta)
        } else {
            changeEndMinute(by: modify.rawValue * minuteDelta)
        }
    }
    
    func modifyHour(type: TimeType, modify: ModifyType) {
        if type == .start {
            changeStartHour(by: modify.rawValue * hourDelta)
        } else {
            changeEndHour(by: modify.rawValue * hourDelta)
        }
    }
    
    // MARK:- Time Adjustment (private - Do not need to change)
    
    private func adjustEndTime() {
        if (startHour > endHour) || (startHour == endHour && startMinute >= endMinute) {
            var newEndHour = startHour
            var newEndMinute = startMinute+minimumMinuteDelta
            newEndHour += (newEndMinute / 60)
            newEndMinute %= 60
            
            newEndHour %= 24
            if newEndHour < 0 {
                newEndHour += 24
            }
            
            endHour = newEndHour
            endMinute = newEndMinute
        }
    }
    
    private func adjustStartTime() {
        if !isExtend && (startHour > endHour) || (startHour == endHour && startMinute >= endMinute) {
            var newStartHour = endHour
            var newStartMinute = endMinute-minimumMinuteDelta
            if newStartMinute < 0 {
                let hDelta = (newStartMinute / 60) - 1
                newStartMinute += (60 * -hDelta)
                newStartHour += hDelta
            }
            
            newStartHour %= 24
            if newStartHour < 0 {
                newStartHour += 24
            }
            
            startHour = newStartHour
            startMinute = newStartMinute
        }
    }
    
    private func validateStartTime(_ newStartHour: Int, _ newStartMinute: Int) -> Bool {
        let lower = (newStartHour > startHourLowerLimit || (newStartHour == startHourLowerLimit && newStartMinute >= startMinuteLowerLimit))
        let upper = (newStartHour < startHourUpperLimit || (newStartHour == startHourUpperLimit && newStartMinute <= startMinuteUpperLimit))
        
        return lower && upper
    }
    
    private func validateEndTime(_ newEndHour: Int, _ newEndMinute: Int) -> Bool {
        let lower = (newEndHour > endHourLowerLimit || (newEndHour == endHourLowerLimit && newEndMinute >= endMinuteLowerLimit))
        let upper = (newEndHour < endHourUpperLimit || (newEndHour == endHourUpperLimit && newEndMinute <= endMinuteUpperLimit))
        
        return lower && upper
    }
    
    private func adjustStartUpperLimit() {
        if startHour > startHourUpperLimit {
            startHour = startHourUpperLimit
            startMinute = startMinuteUpperLimit
        } else if startHour == startHourUpperLimit && startMinute > startMinuteUpperLimit {
            startMinute = startMinuteUpperLimit
        }
    }
    
    private func adjustStartLowerLimit() {
        if startHour < startHourLowerLimit {
            startHour = startHourLowerLimit
            startMinute = startMinuteLowerLimit
        } else if startHour == startHourLowerLimit && startMinute < startMinuteLowerLimit {
            startMinute = startMinuteLowerLimit
        } else {
            startHourLowerLimit = startHour
            startMinuteLowerLimit = startMinute
        }
    }
    
    private func adjustEndUpperLimit() {
        if endHour > endHourUpperLimit {
            endHour = endHourUpperLimit
            endMinute = endMinuteUpperLimit
        } else if endHour == endHourUpperLimit && endMinute > endMinuteUpperLimit {
            endMinute = endMinuteUpperLimit
        }
    }
    
    private func adjustEndLowerLimit() {
        if endHour < endHourLowerLimit {
            endHour = endHourLowerLimit
            endMinute = endMinuteLowerLimit
        } else if endHour == endHourLowerLimit && endMinute < endMinuteLowerLimit {
            endMinute = endMinuteLowerLimit
        } else {
            endHourLowerLimit = endHour
            endMinuteLowerLimit = endMinute
        }
    }
    
    private func changeStartHour(by: Int) {
        let newStartHour = startHour + by
        
        if !validateStartTime(newStartHour, startMinute) {
            return
        }
        
        startHour = newStartHour
        
        adjustEndTime()
    }
    
    private func changeStartMinute(by: Int) {
        var newStartMinute = startMinute + by
        var newStartHour = startHour
        if newStartMinute >= 60 {
            newStartHour += (newStartMinute / 60)
            newStartMinute %= 60
        } else if newStartMinute < 0 {
            let hDelta = (newStartMinute / 60) - 1
            newStartMinute += (60 * -hDelta)
            newStartHour += hDelta
        }
        
        if !validateStartTime(newStartHour, newStartMinute) {
            return
        }
        
        startHour = newStartHour
        startMinute = newStartMinute
        
        adjustEndTime()
    }
    
    private func changeEndHour(by: Int) {
        let newEndHour = endHour + by
        
        if !validateEndTime(newEndHour, endMinute) {
            return
        }
        
        endHour = newEndHour
        
        adjustStartTime()
    }
    
    private func changeEndMinute(by: Int) {
        var newEndMinute = endMinute + by
        var newEndHour = endHour
        if newEndMinute >= 60 {
            newEndHour += (newEndMinute / 60)
            newEndMinute %= 60
        } else if newEndMinute < 0 {
            let hDelta = (newEndMinute / 60) - 1
            newEndMinute += (60 * -hDelta)
            newEndHour += hDelta
        }
        
        if !validateEndTime(newEndHour, newEndMinute) {
            return
        }
        
        endHour = newEndHour
        endMinute = newEndMinute
        
        adjustStartTime()
    }
}
