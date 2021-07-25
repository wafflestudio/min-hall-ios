//
//  SeatInfo.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/25.
//

import Foundation
import SwiftUI

enum SeatStatus: String {
    case available = "SeatAvailable"
    case occupied = "SeatOccupied"
    case disabled = "SeatDisabled"
}

struct SeatInfo {
    var id: Int
    var x: CGFloat
    var y: CGFloat
    var status: SeatStatus
    var angle: Angle = Angle(degrees: 0)
}
