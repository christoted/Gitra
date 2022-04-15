//  Settings.swift
//  Gitra
//
//  Created by Gilang Adrian on 11/06/21.
//

import Foundation

enum SettingKey: String {
    case inputMode
    case welcomeScreen
    case inputCommand
    case chordSpeed
}

enum SettingType {
    case toggle
    case disclosure
    case options
    case checkmark
}

struct SettingMenu {
    let title: String
    let type: SettingType
    
    var child: [SettingMenu]?
    var saveKey: SettingKey?
    var value: Int?
}

class SettingsDatabase {
    static let shared = SettingsDatabase()
    
    private var settings: [SettingMenu]
    
    private let chordSpeedChild: [SettingMenu] = [
        SettingMenu(title: "Slow", type: .checkmark),
        SettingMenu(title: "Normal", type: .checkmark),
        SettingMenu(title: "Fast", type: .checkmark)
    ]
    
    private let instructionChild: [SettingMenu] = [
        SettingMenu(title: "Voice Command Mode", type: .disclosure),
        SettingMenu(title: "Picker Mode", type: .disclosure),
        SettingMenu(title: "Automatic Tuner", type: .disclosure)
    ]
    
    init() {
        settings = [
            SettingMenu(title: "Welcome Screen", type: .toggle, saveKey: .welcomeScreen),
            SettingMenu(title: "Input Command Guide", type: .toggle, saveKey: .inputCommand),
            SettingMenu(title: "Chord Speed", type: .options, child: chordSpeedChild, saveKey: .chordSpeed),
            SettingMenu(title: "Instructions", type: .disclosure, child: instructionChild)
        ]
    }
}

extension SettingsDatabase {
    
    func getSettings() -> [SettingMenu] {
        return settings
    }
    
}
