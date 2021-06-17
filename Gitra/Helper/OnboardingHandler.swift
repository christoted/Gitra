//
//  OnboardingHandler.swift
//  Gitra
//
//  Created by Yahya Ayyash on 17/06/21.
//

import Foundation

class OnboardingHandler {
    static let shared = OnboardingHandler()
    
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: #function)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
}
