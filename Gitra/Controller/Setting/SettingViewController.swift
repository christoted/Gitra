//
//  SettingViewController.swift
//  Gitra
//
//  Created by Christopher Teddy  on 07/06/21.
//

import UIKit

//UIColor.ColorLibrary

class SettingViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    let settingsList = Settings.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension SettingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch(indexPath.row){
        case 0: performSegue(withIdentifier: "SettingsToDesc", sender: nil)
        case 3: performSegue(withIdentifier: "SettingsToSpeed", sender: nil)
        case 4: performSegue(withIdentifier: "SettingsToInst", sender: nil)
        default: print("default nih")
        }
    }
    
    // func tableViewShouldReturn(_ tableView: UITableView) -> Bool {
    //   userDefaults.setValue(tableView.text, forKey: "settings")
    //}
    
}

extension SettingViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.getSettings().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "SettingsTableViewCell")
        cell.textLabel?.text = settingsList.getSettings()[indexPath.row].titleSettings
        
        let selected = settingsList.getSettings()[indexPath.row].selected
        
        //switch
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        // click/toggle/desc
        if settingsList.getSettings()[indexPath.row].type == .click{
            cell.accessoryType = .disclosureIndicator
        } else if settingsList.getSettings()[indexPath.row].type == .toggle{
            cell.accessoryView = switchView
            if selected == 1{
                switchView.setOn(true, animated: true)
            } else {
                switchView.setOn(false, animated: true)
            }
            
        } else if settingsList.getSettings()[indexPath.row].type == .description{
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = settingsList.getSettings()[indexPath.row].menu?[selected ?? 0]
        }
        
        return cell
    }
    
    @objc func switchChanged( sender: UISwitch!){
        let status = sender.isOn ? 1 : 0
        
        if sender.tag == 1{
            UserDefaults.standard.set(status, forKey: "welcomeScreen")
        }else{
            UserDefaults.standard.set(status, forKey: "inputCommand")
        }
    }
}
