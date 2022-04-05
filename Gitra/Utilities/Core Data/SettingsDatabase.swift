//  Settings.swift
//  Gitra
//
//  Created by Gilang Adrian on 11/06/21.
//

import Foundation

enum TypeSetting {
    case toggle
    case click
    case description
}

enum SettingKeys: String {
    case inputMode
    case welcomeScreen
    case inputCommand
    case chordSpeed
}

struct SettingsType {
    let title: String
    let type: TypeSetting
    var selected: Int?
    var menu: [String]?
    var key: SettingKeys?
}

class SettingsDatabase {
    static let shared = SettingsDatabase()
    
    var inputModes: Int
    var welcomeScreen: Int
    var inputCommand: Int
    var chordSpeed: Int
    
    private var settings = [SettingsType]()
    
    init() {
        self.inputModes = UserDefaults.standard.integer(forKey: SettingKeys.inputMode.rawValue)
        self.welcomeScreen = UserDefaults.standard.integer(forKey: SettingKeys.welcomeScreen.rawValue)
        self.inputCommand = UserDefaults.standard.integer(forKey: SettingKeys.inputCommand.rawValue)
        self.chordSpeed = UserDefaults.standard.integer(forKey: SettingKeys.chordSpeed.rawValue)
        
        settings = [
            SettingsType(title: "Welcome Screen", type: .toggle, selected: welcomeScreen, key: .welcomeScreen),
            SettingsType(title: "Input Command Guides", type: .toggle, selected: inputCommand, key: .inputCommand),
            SettingsType(title: "Chord Speed", type: .description, selected: chordSpeed, menu: ["Slow", "Normal", "Fast"], key: .chordSpeed),
            SettingsType(title: "Instructions", type: .click, menu: ["Voice Command Mode", "Picker Mode", "Automatic Tuner"])]
    }
}

extension SettingsDatabase {
    
    func reloadDatabase(){
        self.inputModes = UserDefaults.standard.integer(forKey: SettingKeys.inputMode.rawValue)
        self.welcomeScreen = UserDefaults.standard.integer(forKey: SettingKeys.welcomeScreen.rawValue)
        self.inputCommand = UserDefaults.standard.integer(forKey: SettingKeys.inputCommand.rawValue)
        self.chordSpeed = UserDefaults.standard.integer(forKey: SettingKeys.chordSpeed.rawValue)
        
        settings = [
            SettingsType(title: "Welcome Screen", type: .toggle, selected: welcomeScreen, key: .welcomeScreen),
            SettingsType(title: "Input Command Guides", type: .toggle, selected: inputCommand, key: .inputCommand),
            SettingsType(title: "Chord Speed", type: .description, selected: chordSpeed, menu: ["Slow", "Normal", "Fast"], key: .chordSpeed),
            SettingsType(title: "Instructions", type: .click, menu: ["Voice Command Mode", "Picker Mode", "Automatic Tuner"])]
    }
    
    func getSettings() -> [SettingsType] {
        reloadDatabase()
        return settings
    }
    
}
