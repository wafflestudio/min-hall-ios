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
    var id: String
    var x: CGFloat
    var y: CGFloat
    var status: SeatStatus
    var angle: Angle = Angle(degrees: 0)
    
    init(id: String, x: CGFloat, y: CGFloat, status: SeatStatus = .available, angle: Double = 0) {
        self.id = id
        self.x = x
        self.y = y
        self.status = status
        self.angle = Angle(degrees: angle)
    }
    
    init(id: String, coordinate: CGPoint, status: SeatStatus = .available, angle: Double = 0) {
        self.id = id
        self.x = coordinate.x
        self.y = coordinate.y
        self.status = status
        self.angle = Angle(degrees: angle)
    }
    
    static let angles: [String: Double] = [
        "B1": -30,
        "B2": -30,
    ]
    
    static let coordinates: [String : CGPoint] = [
        "A1": CGPoint(x: 61, y: 384),
        "A2": CGPoint(x: 61, y: 463),
        "A3": CGPoint(x: 61, y: 543),
        "A4": CGPoint(x: 61, y: 622),
        "A5": CGPoint(x: 233, y: 384),
        "A6": CGPoint(x: 233, y: 463),
        "A7": CGPoint(x: 233, y: 543),
        "A8": CGPoint(x: 233, y: 622),
        "B1": CGPoint(x: 259, y: 234),
        "B2": CGPoint(x: 312, y: 204),
        "C1": CGPoint(x: 442.5, y: 575.5),
        "C2": CGPoint(x: 523.5, y: 575.5),
        "C3": CGPoint(x: 442.5, y: 713),
        "C4": CGPoint(x: 523.5, y: 713),
        "D1": CGPoint(x: 481, y: 58.5),
        "D2": CGPoint(x: 571.5, y: 58.5),
        "D3": CGPoint(x: 662.5, y: 58.5),
        "D4": CGPoint(x: 742.5, y: 145),
        "D5": CGPoint(x: 742.5, y: 357.5),
        "D6": CGPoint(x: 742.5, y: 455),
        "D7": CGPoint(x: 465, y: 204),
        "D8": CGPoint(x: 526.6, y: 204),
        "D9": CGPoint(x: 382.5, y: 347),
        "D10": CGPoint(x: 440, y: 289.5),
        "D11": CGPoint(x: 590.5, y: 234),
        "D12": CGPoint(x: 590.5, y: 291),
        "D13": CGPoint(x: 495.5, y: 455.5),
        "D14": CGPoint(x: 556, y: 455.5),
        "E1": CGPoint(x: 926.5, y: 117),
        "E2": CGPoint(x: 926.5, y: 185),
        "E3": CGPoint(x: 926.5, y: 252),
        "E4": CGPoint(x: 926.5, y: 320),
        "E5": CGPoint(x: 926.5, y: 391),
        "E6": CGPoint(x: 926.5, y: 459),
        "E7": CGPoint(x: 926.5, y: 527),
        "E8": CGPoint(x: 926.5, y: 595.5),
        "E9": CGPoint(x: 1092.5, y: 117),
        "E10": CGPoint(x: 1092.5, y: 185),
        "E11": CGPoint(x: 1092.5, y: 252),
        "E12": CGPoint(x: 1092.5, y: 320),
        "E13": CGPoint(x: 1092.5, y: 391),
        "E14": CGPoint(x: 1092.5, y: 459),
        "E15": CGPoint(x: 1092.5, y: 527),
        "E16": CGPoint(x: 1092.5, y: 595.5),
        "F1": CGPoint(x: 1271, y: 58.5),
        "F2": CGPoint(x: 1351, y: 58.5),
        "F3": CGPoint(x: 1179.5, y: 216),
        "F4": CGPoint(x: 1343, y: 216),
        "F5": CGPoint(x: 1179.5, y: 333.5),
        "F6": CGPoint(x: 1343, y: 333.5),
        "F7": CGPoint(x: 1271, y: 488.5),
        "F8": CGPoint(x: 1351, y: 488.5),
        "G1": CGPoint(x: 1520, y: 58.5),
        "G2": CGPoint(x: 1642, y: 58.5),
        "G3": CGPoint(x: 1503.5, y: 216),
        "G4": CGPoint(x: 1656, y: 216),
        "G5": CGPoint(x: 1503.5, y: 333.5),
        "G6": CGPoint(x: 1656, y: 333.5),
        "H1": CGPoint(x: 1485.5, y: 575),
        "H2": CGPoint(x: 1566, y: 575),
        "H3": CGPoint(x: 1485.5, y: 713.5),
        "H4": CGPoint(x: 1566, y: 713.5),
        "I1": CGPoint(x: 1751.5, y: 524),
        "I2": CGPoint(x: 1751.5, y: 600),
    ]
    
}
