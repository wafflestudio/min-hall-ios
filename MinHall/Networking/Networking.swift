//
//  Networking.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/11.
//

import Foundation
import Alamofire
import Combine
import SwiftyUserDefaults

class Networking {
    static let shared = Networking()
    
    private let session: Session // custom session for retrier & adapter usage
    
    private init() {
        session = Session(interceptor: AuthInterceptor())
    }
    
    private func errorHandler<T>(error: AFError) -> Combine.Empty<T, Never> {
        if let error = error.underlyingError as? MHError {
            AppState.shared.system.error = error.needAlert
            AppState.shared.system.errorMessage = error.message
        }
        
        return Combine.Empty<T, Never>()
    }
    
    private func validation(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> Result<Void, Error> {
        if (200..<300) ~= response.statusCode {
            return .success(())
        } else if response.statusCode == 401 {
            return .failure(MHError.unauthorized)
        } else if response.statusCode == 403 {
            return .failure(MHError.forbidden)
        } else if response.statusCode == 404 {
            return .failure(MHError.network)
        } else if response.statusCode == 500 {
            return .failure(MHError.serverError)
        } else {
            let decoder = JSONDecoder()
            if let data = data,
               let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                #if DEBUG
                print(errorResponse.code)
                print(errorResponse.message)
                #endif
                return .failure(MHError.init(code: errorResponse.code))
            } else {
                return .failure(MHError.unknown)
            }
        }
    }
    
    func login(username: String, password: String) -> AnyPublisher<TokenResponse, Never> {
        // Do not use custom session because it should not use interceptor
        let request = AF.request(MinHallAPI.login(username: username, password: password))
        
        return request.validate(validation).publishDecodable(type: TokenResponse.self)
            .value()
            .catch(errorHandler)
            .handleEvents(receiveOutput: { tokenResponse in
                Defaults[\.accessToken] = tokenResponse.token
                Defaults[\.username] = username
                Defaults[\.password] = password
            })
            .eraseToAnyPublisher()
    }
    
    func getMyReservation() -> AnyPublisher<Reservation, Never> {
        let request = session.request(MinHallAPI.getReservation)
        return request.validate(validation).publishDecodable(type: Reservation.self)
            .value()
            .catch(errorHandler)
            .eraseToAnyPublisher()
    }
    
    func makeReservation(
        studentId: String,
        seatId: String,
        startAt: String,
        endAt: String
    ) -> AnyPublisher<Reservation, Never> {
        let request = session.request(
            MinHallAPI.postReservation(studentId: studentId, seatId: seatId, startAt: startAt, endAt: endAt)
        )
        return request.validate(validation).publishDecodable(type: Reservation.self)
            .value()
            .catch(errorHandler)
            .eraseToAnyPublisher()
    }
    
    func cancelReservation(reservationId: Int) -> AnyPublisher<Bool, Never> {
        let request = session.request(MinHallAPI.deleteReservation(id: reservationId))
        return request.validate(validation).publishData()
            .value()
            .catch(errorHandler)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func getSeats(startAt: String, endAt: String) -> AnyPublisher<SeatResponse, Never> {
        let request = session.request(MinHallAPI.getSeats(startAt: startAt, endAt: endAt))
        return request.validate(validation).publishDecodable(type: SeatResponse.self)
            .value()
            .catch(errorHandler)
            .eraseToAnyPublisher()
    }
}
