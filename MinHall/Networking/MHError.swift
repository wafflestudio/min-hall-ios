//
//  Error.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/11.
//

import Foundation
import Alamofire

enum MHError: String, Error {
    init(_ error: AFError) {
        self = .network
    }
    
    init(code: String) {
        self = (.init(rawValue: code) ?? .network)
    }
    
    // Client Error
    case unknown = "0000"
    case missingToken = "0001"
    case unauthorized = "0401"
    case forbidden = "0403"
    case network = "0404"
    case serverError = "0500"
    
    // Common
    case invalidCode = "C001"
    case resourceNotFound = "C002"
    case expiredCode = "C003"
    case parseException = "C004"
    case messageLengthExcess = "C005"
    case userNumberInvalid = "C006"
    case timeInvalid = "C007"
    
    // User
    case userNotFound = "U001"
    case studentUnavailable = "U004"
    case studentUnauthorized = "U005"
    
    // Reservation
    case reservationNotFound = "R001"
    case todayReservationNotFound = "R002"
    case reservationNumberExceed = "R003"
    case reservationTimeInvalid = "R004"
    
    // Seat
    case seatNotFound = "S001"
    case seatUnavailable = "S003"
    
    // Login
    case passwordNotValid = "L001"
    case tokenError = "L002"
    case loginFailure = "L003"
    
    var message: String? {
        switch self {
        case .network:
            return "네트워크 연결을 확인해주세요."
        case .missingToken:
            return "로그인을 다시 시도해주세요."
            
        case .forbidden:
            return "권한이 없습니다."
        case .unauthorized:
            return "인증에 실패했습니다."
        case .serverError:
            return "서버 에러입니다. 잠시 후 다시 시도해주세요."
            
        case .timeInvalid:
            return "올바르지 않은 시간입니다."
        case .studentUnavailable:
            return "경고 조치로 인해 예약이 불가능합니다."
        case .studentUnauthorized:
            return "권한이 없습니다."
            
        case .reservationNotFound:
            return "없는 예약입니다."
        case .todayReservationNotFound:
            return nil
        case .reservationNumberExceed:
            return "이미 오늘 좌석을 예약하셨습니다."
        case .reservationTimeInvalid:
            return "예약이 불가능한 시간입니다."
            
        case .seatNotFound:
            return "없는 좌석입니다."
        case .seatUnavailable:
            return "좌석 이용이 불가능합니다."
            
        case .passwordNotValid:
            return "비밀번호가 틀렸습니다."
        case .tokenError:
            return "로그인을 다시 시도해주세요."
        case .loginFailure:
            return "로그인을 실패했습니다."
            
        default:
            return "알 수 없는 오류입니다. 다시 시도해주세요."
        }
    }
    
    var needAlert: Bool {
        switch self {
        case .todayReservationNotFound, .missingToken:
            return false
        default:
            return true
        }
    }
}
