//
//  SettingViewController.swift
//  Gitra
//
//  Created by Christopher Teddy  on 07/06/21.
//

import UIKit

enum typeSetting{
    case toggle
    case click
}

struct settingsType{
    var titleSettings : String
    var type : typeSetting
}

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //var settings = ["Chord input mode", "Welcome screen", "Input command guides", "Chord speed", "Instructions"]
    let settings = [settingsType(titleSettings: "Chord input mode", type: .click),
                   settingsType(titleSettings: "Welcome screen", type: .toggle),
                   settingsType(titleSettings: "Input command guides", type: .toggle),
                   settingsType(titleSettings: "Chord speed", type: .click),
                   settingsType(titleSettings: "Instructions", type: .click)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // TableView Funcs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell",
                                                 for: indexPath) as! SettingsTableViewCell
        cell.cellLabel.text = settings[indexPath.row].titleSettings
        cell.cellImageView.backgroundColor = .yellow
        //cell.textLabel?.text = settings[indexPath.row]
        
        return cell
    }
    
}


//if type ==.toggle{
  //  return cellproto1
//}

//extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
  //  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    print("You selected \([indexPath.row]).")
    //}
//}
