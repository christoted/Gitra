//
//  SettingViewModel.swift
//  Gitra
//
//  Created by Yahya Ayyash on 05/04/22.
//

import Foundation

class SettingViewViewModel {
    var settingList: [SettingViewModel]
    
    init() {
        let settingData = SettingsDatabase.shared.getSettings()
        self.settingList = settingData.map{ SettingViewModel.init(setting: $0) }
    }
}

extension SettingViewViewModel {
    func settingListCount() -> Int {
        return settingList.count
    }
    
    func settingForRow(at index: Int) -> SettingViewModel {
        return settingList[index]
    }
    
    func reloadData() {
        let settingData = SettingsDatabase.shared.getSettings()
        settingList = settingData.map{ SettingViewModel.init(setting: $0) }
    }
    
    func toggleSettings(value: Int, forKey key: SettingKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}

struct SettingViewModel {
    let setting: SettingsType
}

extension SettingViewModel {
    
    var title: String {
        return setting.title
    }
    
    var type: TypeSetting {
        return setting.type
    }
    
    var selected: Int {
        return setting.selected ?? 0
    }
    
    var menu: [String]? {
        return setting.menu
    }
    
    var selectedMenu: String {
        return setting.menu?[selected] ?? ""
    }
    
    var key: SettingKeys? {
        return setting.key
    }
    
}
