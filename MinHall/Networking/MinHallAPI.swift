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
    case postReservation(studentId: String, seatId: String, startAt: String, endAt: String)
    case deleteReservation(id: Int)
    case getSeats(startAt: String, endAt: String)
    
    static var baseURL = Config.shared.serverURL!
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .postReservation:
            return .post
        case .getReservation:
            return .get
        case .deleteReservation:
            return .delete
        case .getSeats:
            return .get
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .postReservation:
            return "/reservations/"
        case .getReservation:
            return "/reservations/me"
        case let .deleteReservation(id):
            return "/reservations/\(id)"
        case .getSeats:
            return "/seats/"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .login(username, password):
            return ["username": username, "password": password]
        case let .postReservation(studentId, seatId, startAt, endAt):
            return ["studentId": studentId, "seatId": seatId, "startAt": startAt, "endAt": endAt]
        case .getReservation:
            return nil
        case .deleteReservation:
            return nil
        case let .getSeats(startAt, endAt):
            return ["startAt": startAt, "endAt": endAt]
        }
    }
}
