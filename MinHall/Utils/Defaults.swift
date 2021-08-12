//
//  Defaults.swift
//  MinHall
//
//  Created by 박종석 on 2021/08/11.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var accessToken: DefaultsKey<String?>{ .init("accessToken") }
    
    var username: DefaultsKey<String?> { .init("username") }
    var password: DefaultsKey<String?> { .init("password") }
    
    var reserved: DefaultsKey<Bool> { .init("reserved", defaultValue: false) }
}
