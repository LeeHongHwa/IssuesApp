//
//  GlobalState.swift
//  IssuesApp
//
//  Created by david on 2017. 10. 28..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import Foundation

//유저디폴트
final class GlobalState {
    static let instance = GlobalState()
    //질문: raw 가아니면 어떤 값일까 ??
    enum Constants: String {
        case tokenKey
        case refreshToken
    }
    
    var token: String? {
        get {
            let token = UserDefaults.standard.string(forKey: Constants.tokenKey.rawValue)
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.tokenKey.rawValue)
        }
    }
    
    var refreshToken: String? {
        get {
            let token = UserDefaults.standard.string(forKey: Constants.refreshToken.rawValue)
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.refreshToken.rawValue)
        }
    }
}
