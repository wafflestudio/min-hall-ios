//
//  Utils.swift
//  MinHall
//
//  Created by 박종석 on 2021/07/20.
//

import Foundation
import UIKit

class MapUtil {
    static let mapWidth: CGFloat = 1904
    static let mapHeight: CGFloat = 772
    static let miniMapWidth: CGFloat = 184
    static let miniMapHeight: CGFloat = 80
    
    static let seatSize: CGFloat = 42
    static let miniSeatSize: CGFloat = 4.5
    
    
    static func transformCoordinate(_ x: CGFloat, _ y: CGFloat, frameWidth: CGFloat = miniMapWidth, frameHeight: CGFloat = miniMapHeight) -> CGPoint {
        return CGPoint(x: x * frameWidth/mapWidth, y: y * frameHeight / mapHeight)
    }
    
    static func transformXOffset(_ x: CGFloat, zoom: CGFloat) -> CGFloat {
        return miniMapWidth * x / (zoom * mapWidth)
    }

    static func transformYOffset(_ y: CGFloat, zoom: CGFloat) -> CGFloat {
        return miniMapHeight * y / (zoom * mapHeight)
    }

    static func getBoxWidth(zoom: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        
        return (screenWidth * miniMapWidth) / (zoom * mapWidth)
    }

    static func getBoxHeight(zoom: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height-200
        
        return (screenHeight * miniMapHeight) / (zoom * mapHeight)
    }

}
