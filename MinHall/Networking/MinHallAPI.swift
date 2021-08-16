//
//  MinHallApi.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/11.
//

import Foundation
import SwiftyUserDefaults
import Alamofire

enum MinHallAPI: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: URL(string: Self.baseURL + path)!)
        
        #if DEBUG
        print(Self.baseURL + path)
        #endif
        
        request.method = self.method
        switch self.method {
        case .get, .delete:
            return try Alamofire.URLEncoding.default.encode(request, with: self.parameters)
        default:
            return try Alamofire.JSONEncoding.default.encode(request, with: self.parameters)
        }
    }
    
    case login(username: String, password: String)
    case getReservation
    case postReservation(seatId: String, startAt: String, endAt: String)
    case patchReservation(id: Int, endAt: String)
    case deleteReservation(id: Int)
    case getSeats(startAt: String, endAt: String)
    case getOperatingTime
    case getNotification
    case getWarning
    
    static var baseURL = Config.shared.serverURL!
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getReservation:
            return .get
        case .postReservation:
            return .post
        case .patchReservation:
            return .patch
        case .deleteReservation:
            return .delete
        case .getSeats:
            return .get
        case .getOperatingTime:
            return .get
        case .getNotification:
            return .get
        case .getWarning:
            return .get
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .getReservation:
            return "/reservations/me"
        case .postReservation:
            return "/reservations"
        case let .patchReservation(id, _):
            return "/reservations/\(id)"
        case let .deleteReservation(id):
            return "/reservations/\(id)"
        case .getSeats:
            return "/seats"
        case .getOperatingTime:
            return "/reservations/settings"
        case .getNotification:
            return "/reservations/notice"
        case .getWarning:
            return "/reservations/warning"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .login(username, password):
            return ["username": username, "password": password]
        case .getReservation:
            return nil
        case let .postReservation(seatId, startAt, endAt):
            return ["seatId": seatId, "startAt": startAt, "endAt": endAt]
        case let .patchReservation(_, endAt):
            return ["endAt": endAt]
        case .deleteReservation:
            return nil
        case let .getSeats(startAt, endAt):
            return ["startAt": startAt, "endAt": endAt]
        case .getOperatingTime:
            return nil
        case .getNotification:
            return nil
        case .getWarning:
            return nil
        }
    }
}
