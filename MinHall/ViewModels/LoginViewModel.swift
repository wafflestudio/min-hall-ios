//
//  LoginViewModel.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/12.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var loading: Bool = false
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var destinationURL: String? = nil
    @Published var showSheet: Bool = false
    
    @Published var loggedIn: Bool = false
    
    var onLoggedIn: () -> Void = {}
    
    init() {
        $loggedIn
            .filter { $0 }
            .sink { [weak self] _ in
                self?.onLoggedIn()
            }
            .store(in: &cancellables)
        
        $destinationURL
            .filter { $0 != nil }
            .removeDuplicates()
            .map { _ in true }
            .receive(on: RunLoop.main)
            .assign(to: \.showSheet, on: self)
            .store(in: &cancellables)
    }
    
    func login() {
        self.loading = true
        
        Networking.shared.login(username: username, password: password)
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] token in
                self?.loading = false
                AppState.shared.system.accessToken = token.token
            }, receiveCompletion: { [weak self] _ in
                self?.loading = false
            })
            .map { _ in true }
            .assign(to: \.loggedIn, on: self)
            .store(in: &cancellables)
    }
}
