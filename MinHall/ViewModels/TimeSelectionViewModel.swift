//
//  TimeSelectionViewModel.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import Foundation
import Combine

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
    
    @Published var showAnnounce: Bool = true
    @Published var announce: String = "공간 사용 시 외부 음식물은 섭취할 수 없습니다. 당일 예약만 가능하며, 좌석 예약 후 사용하지 않을 시 경고 조치되며 경고 2회 누적 시 익일 사용 불가합니다."
    
    @Published var startHour: Int = 0
    @Published var startMinute: Int = 0
    
    @Published var endHour: Int = 0
    @Published var endMinute: Int = 0
    
    @Published var today: String
    
    @Published var toSeatSelect = false
    @Published var isExtend = false
    
    var onReserved: () -> Void = {}
    
    private var startHourLowerLimit = -1
    private var startMinuteLowerLimit = -1
    private var endHourLowerLimit = -1
    private var endMinuteLowerLimit = -1
    
    private let startHourUpperLimit = 23
    private let startMinuteUpperLimit = 00
    private let endHourUpperLimit = 23
    private let endMinuteUpperLimit = 30
    
    init() {
        formatter.locale = Locale(identifier: "ko_kr")
        
        formatter.dateFormat = "yyyy / MM / dd"
        today = formatter.string(from: now)
        
        setupTimes()
        
        $startHour
            .combineLatest($startMinute)
            .removeDuplicates { $0.0 == $1.0 && $0.1 == $1.1 }
            .sink { (hour, minute) in
                AppState.shared.setStartTime(time: String(format: "%02d:%02d", hour, minute))
            }
            .store(in: &cancellables)
        
        $endHour
            .combineLatest($endMinute)
            .removeDuplicates { $0.0 == $1.0 && $0.1 == $1.1 }
            .sink { (hour, minute) in
                AppState.shared.setEndTime(time: String(format: "%02d:%02d", hour, minute))
            }
            .store(in: &cancellables)
    }
    
    private func setupTimes() {
        switch AppState.shared.reservationState {
        case .none:
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
            
            endMinute = startMinute + 30
            endHour = startHour + (endMinute / 60)
            if endHour >= 24 {
                endHour = 0
                endMinute = 0
            } else {
                endMinute %= 60
            }
            
            self.startHourLowerLimit = self.startHour
            self.startMinuteLowerLimit = self.startMinute
            self.endHourLowerLimit = self.endHour
            self.endMinuteLowerLimit = self.endMinute
        case let .reserved(startTime, endTime, _):
            let startTimeSplit = startTime.split(separator: ":")
            self.startHour = Int(startTimeSplit[0]) ?? 0
            self.startMinute = Int(startTimeSplit[1]) ?? 0
            let endTimeSplit = endTime.split(separator: ":")
            self.endHour = Int(endTimeSplit[0]) ?? 0
            self.endMinute = Int(endTimeSplit[1]) ?? 0
            
            self.endHourLowerLimit = self.endHour
            self.endMinuteLowerLimit = self.endMinute
            self.isExtend = true
            self.showAnnounce = false
        default:
            return
        }
    }
    
    func makeReservation() {
        let valid = AppState.shared.setReserved()
        if valid {
            // .. send request
            
            onReserved()
        }
    }
    
    func getHour(type: TimeType) -> Int {
        if type == .start {
            return self.startHour
        } else {
            return self.endHour
        }
    }
    
    func getMinute(type: TimeType) -> Int {
        if type == .start {
            return self.startMinute
        } else {
            return self.endMinute
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
    
    // MARK:- Time Adjustment (private)
    
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
