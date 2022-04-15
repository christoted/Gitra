//
//  SettingViewController.swift
//  Gitra
//
//  Created by Christopher Teddy  on 07/06/21.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var settingVM = SettingViewViewModel()
    var sender: SettingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? SettingListViewController
        destination?.source = self.sender
    }
    
    func setupUI() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Identify the sender
        sender = settingVM.settingForRow(at: indexPath.row)
        
        let currCellType = settingVM.settingForRow(at: indexPath.row).type
        
        // If current cell isn't toggle, perform segue
        if currCellType != .toggle {
            // TODO: Store identifier in enum
            performSegue(withIdentifier: "SettingsListSegue", sender: nil)
        }
    }
}

// MARK: - TableView Datasource
extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingVM.settingListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Store identifier in enum
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "SettingsTableViewCell")
        
        let currCell = settingVM.settingForRow(at: indexPath.row)
        
        // TODO: Consider moving this to make it reusable
        let switchView = UISwitch(frame: .zero)
        switchView.onTintColor = .ColorLibrary.yellowAccent
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        cell.textLabel?.text = currCell.title
        
        switch currCell.type {
        case .disclosure:
            cell.accessoryType = .disclosureIndicator
        case .options:
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = currCell.childTitle
        case .toggle:
            cell.accessoryView = switchView
            switchView.setOn(currCell.value == 1, animated: true)
        case .checkmark:
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    @objc func switchChanged(_ sender: UISwitch!) {
        let status = sender.isOn ? 1 : 0
        
        switch sender.tag {
        case 0:
            // Welcome Screen Toggle
            settingVM.toggleSettings(value: status, forKey: .welcomeScreen)
        case 1:
            // Input Command Toggle
            settingVM.toggleSettings(value: status, forKey: .inputCommand)
        default:
            break
        }
    }
}
