//
//  AppState.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/24.
//

import Foundation

class AppState {
    enum ReservationState {
        case none
        case timeSaved(startTime: String, endTime: String)
        case seatSaved(startTime: String, endTime: String, seatId: Int)
        case extendedTimeSaved(startTime: String, endTime: String, newEndTime: String, seatId: Int)
        case reserved(startTime: String, endTime: String, seatId: Int)
    }
    
    static let shared = AppState()
    
    var accessToken: String
    var reservationState: ReservationState = .none
    
    private init() {
        self.accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    }
    
    func cancelReservation() {
        self.reservationState = .none
    }
    
    func setReserved() -> Bool {
        switch self.reservationState {
        case let .seatSaved(startTime, endTime, seatId):
            self.reservationState = .reserved(startTime: startTime, endTime: endTime, seatId: seatId)
            return true
        case let .extendedTimeSaved(startTime, _, newEndTime, seatId):
            self.reservationState = .reserved(startTime: startTime, endTime: newEndTime, seatId: seatId)
            return true
        default:
            return false
        }
    }
    
    func setStartTime(time: String) {
        switch self.reservationState {
        case .none:
            self.reservationState = .timeSaved(startTime: time, endTime: "")
        case let .timeSaved(_, endTime):
            self.reservationState = .timeSaved(startTime: time, endTime: endTime)
        default:
            return
        }
    }
    
    func setEndTime(time: String) {
        switch self.reservationState {
        case .none:
            self.reservationState = .timeSaved(startTime: time, endTime: "")
        case let .timeSaved(startTime, _):
            self.reservationState = .timeSaved(startTime: startTime, endTime: time)
        case let .extendedTimeSaved(startTime, endTime, _, seatId):
            self.reservationState = .extendedTimeSaved(startTime: startTime, endTime: endTime, newEndTime: time, seatId: seatId)
        case let .reserved(startTime, endTime, seatId):
            self.reservationState = .extendedTimeSaved(startTime: startTime, endTime: endTime, newEndTime: time, seatId: seatId)
        default:
            return
        }
    }
    
    func setSeadId(id: Int) {
        switch self.reservationState {
        case let .timeSaved(startTime, endTime):
            self.reservationState = .seatSaved(startTime: startTime, endTime: endTime, seatId: id)
        case let .seatSaved(startTime, endTime, _):
            if id == -1 {
                self.reservationState = .timeSaved(startTime: startTime, endTime: endTime)
            } else {
                self.reservationState = .seatSaved(startTime: startTime, endTime: endTime, seatId: id)
            }
        default:
            return
        }
    }
}
