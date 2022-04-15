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
    
    func toggleSettings(value: Int, forKey key: SettingKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}

struct SettingViewModel {
    let setting: SettingMenu
}

extension SettingViewModel {
    
    var title: String {
        return setting.title
    }
    
    var type: SettingType {
        return setting.type
    }
    
    var value: Int {
        return UserDefaults.standard.integer(forKey: setting.saveKey?.rawValue ?? "")
    }
    
    var child: [SettingViewModel]? {
        return setting.child?.map{ SettingViewModel.init(setting: $0) }
    }
    
    var key: SettingKey? {
        return setting.saveKey
    }
    
    var childTitle: String {
        return setting.child?[value].title ?? ""
    }
    
}
