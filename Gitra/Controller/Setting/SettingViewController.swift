//
//  SettingViewController.swift
//  Gitra
//
//  Created by Christopher Teddy  on 07/06/21.
//

import UIKit

class SettingViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var settingsList = SettingsDatabase.shared.getSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SettingsDatabase.shared.reloadDatabase()
        settingsList = SettingsDatabase.shared.getSettings()
        tableView.reloadData()
    }
    

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsToSpeed"{
            let destination = segue.destination as? ChordSpeedViewController
            destination?.orangTua = self
        }
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
}

extension SettingViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "SettingsTableViewCell")
        
        cell.textLabel?.text = settingsList[indexPath.row].titleSettings
        let selected = settingsList[indexPath.row].selected
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        if settingsList[indexPath.row].type == .click{
            cell.accessoryType = .disclosureIndicator
        } else if settingsList[indexPath.row].type == .toggle{
            cell.accessoryView = switchView
            if selected == 1{
                switchView.setOn(true, animated: true)
            } else {
                switchView.setOn(false, animated: true)
            }
            
        } else if settingsList[indexPath.row].type == .description{
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = settingsList[indexPath.row].menu?[selected ?? 0]
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
