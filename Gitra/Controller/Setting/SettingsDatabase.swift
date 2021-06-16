//  Settings.swift
//  Gitra
//
//  Created by Gilang Adrian on 11/06/21.
//

import Foundation

enum typeSetting{
    case toggle
    case click
    case description
}

struct settingsType{
    var titleSettings : String?
    var type : typeSetting?
    var selected : Int?
    var menu : [String]?
}

class SettingsDatabase{
    static let shared = SettingsDatabase()
    
    var inputModes: Int?
    var welcomeScreen: Int?
    var inputCommand: Int?
    var chordSpeed: Int?
    
    private var settings = [settingsType]()
    
    init() {
        self.inputModes = UserDefaults.standard.integer(forKey: "inputMode")
        self.welcomeScreen = UserDefaults.standard.integer(forKey: "welcomeScreen")
        self.inputCommand = UserDefaults.standard.integer(forKey: "inputCommand")
        self.chordSpeed = UserDefaults.standard.integer(forKey: "chordSpeed")
        
        if UserDefaults.standard.object(forKey: "inputModes") == nil{
            inputModes = 0
        }
        if UserDefaults.standard.object(forKey: "welcomeScreen") == nil{
            welcomeScreen = 1
        }
        if UserDefaults.standard.object(forKey: "inputCommand") == nil{
            inputCommand = 1
        }
        if UserDefaults.standard.object(forKey: "chordSpeed") == nil{
            chordSpeed = 1
        }
        
        settings = [settingsType(titleSettings: "Chord Input Mode", type: .description, selected: inputModes, menu: ["Voice Command", "Picker"]),
                    settingsType(titleSettings: "Welcome Screen", type: .toggle, selected: welcomeScreen),
                    settingsType(titleSettings: "Input Command Guides", type: .toggle, selected: inputCommand),
                    settingsType(titleSettings: "Chord Speed", type: .description, selected: chordSpeed, menu: ["Slow", "Normal", "Fast"]),
                    settingsType(titleSettings: "Instructions", type: .click)]
        
    }
    
    func reloadDatabase(){
        self.inputModes = UserDefaults.standard.integer(forKey: "inputMode")
        self.welcomeScreen = UserDefaults.standard.integer(forKey: "welcomeScreen")
        self.inputCommand = UserDefaults.standard.integer(forKey: "inputCommand")
        self.chordSpeed = UserDefaults.standard.integer(forKey: "chordSpeed")
        
        settings = [settingsType(titleSettings: "Chord Input Mode", type: .description, selected: inputModes, menu: ["Voice Command", "Picker"]),
                    settingsType(titleSettings: "Welcome Screen", type: .toggle, selected: welcomeScreen),
                    settingsType(titleSettings: "Input Command Guides", type: .toggle, selected: inputCommand),
                    settingsType(titleSettings: "Chord Speed", type: .description, selected: chordSpeed, menu: ["Slow", "Normal", "Fast"]),
                    settingsType(titleSettings: "Instructions", type: .click)]
    }
    
    func getSettings() -> [settingsType] {
        return settings
    }
}
