//
//  AuthInterceptor.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/11.
//

import Foundation
import Alamofire
import Combine
import SwiftyUserDefaults

class AuthInterceptor: RequestInterceptor {
    private var cancellables = Set<AnyCancellable>()
    private let retryLimit = 3
    private let retryDelay: TimeInterval = 1
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var tokenUrlRequest = urlRequest
        if let token = Defaults[\.accessToken] {
            tokenUrlRequest.headers.add(.authorization(bearerToken: token))
            completion(.success(tokenUrlRequest))
        } else {
            if let username = Defaults[\.username],
               let password = Defaults[\.password] {
                
                Networking.shared.login(username: username, password: password)
                    .sink { response in
                        Defaults[\.accessToken] = response.token
                        
                        tokenUrlRequest.headers.add(.authorization(bearerToken: response.token))
                        completion(.success(tokenUrlRequest))
                    }
                    .store(in: &cancellables)
                
            } else {
                completion(.failure(MHError.missingToken))
            }
        }
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.response
        if let statusCode = response?.statusCode,
           statusCode == 401,                       // response is unauthorized
           request.retryCount < retryLimit {        // did not exceed retry limit
            if let username = Defaults[\.username],
               let password = Defaults[\.password] {
                
                Networking.shared.login(username: username, password: password)
                    .sink { response in
                        Defaults[\.accessToken] = response.token
                    }
                    .store(in: &cancellables)
                
                completion(.retryWithDelay(retryDelay))
            }
        } else {
            completion(.doNotRetry)
        }
    }
}
