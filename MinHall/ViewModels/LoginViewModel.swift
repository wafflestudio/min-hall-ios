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
    
    @Published var loggedIn: Bool = false
    
    var onLoggedIn: () -> Void = {}
    
    init() {
        $loggedIn
            .filter { $0 }
            .sink { [weak self] _ in
                self?.onLoggedIn()
            }
            .store(in: &cancellables)
    }
    
    func login() {
        self.loading = true
        
        Networking.shared.login(username: username, password: password)
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] token in
                self?.loading = false
            }, receiveCompletion: { [weak self] _ in
                self?.loading = false
            })
            .map { _ in true }
            .assign(to: \.loggedIn, on: self)
            .store(in: &cancellables)
    }
}
