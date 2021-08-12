//
//  Reservation.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/11.
//

import Foundation

struct Reservation: Codable {
    var id: Int? = nil
    var seatId: String = ""
    var startTime: String = ""
    var endTime: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case seatId = "seatId"
        case startTime = "startAt"
        case endTime = "endAt"
    }
    
    func validate() -> Bool {
        return seatId != "" && startTime != "" && endTime != ""
    }
}
