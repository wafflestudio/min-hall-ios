//
//  Responses.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/11.
//

import Foundation

struct TokenResponse: Codable {
    var token: String
}

struct SeatDto: Codable {
    var id: String
    var isAvailable: Bool
    var isReserved: Bool
}

struct SeatResponse: Codable {
    var seatDtoList: [SeatDto]
}

struct ErrorResponse: Codable {
    var status: Int
    var message: String
    var code: String
}
