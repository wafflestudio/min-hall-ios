//
//  Config.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/11.
//

import Foundation

class Config {
    static let shared = Config()
    
    private init() {}
    
    var serverURL: String! = nil
}
