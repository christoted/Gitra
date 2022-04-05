//
//  ChordInputSpeedViewController.swift
//  Gitra
//
//  Created by Gilang Adrian on 10/06/21.
//

import UIKit

class SettingListViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var footerLabel: UILabel!
    
    var source: SettingViewModel?
    var sender: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? InstructionViewController
        destination?.senderPage = self.sender
    }
    
    func setupUI() {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        switch source?.key {
        case .chordSpeed:
            self.title = "Chord Speed"
            footerLabel.text = "Determine the chord playback speed on the instruction mode. The default value is normal."
        default:
            self.title = "Instruction"
            footerLabel.text = ""
        }
    }
    
    func clearAccecoryType() {
        //Deselect all row to remove checkmark
        for i in 0...((source?.menu?.count ?? 0) - 1) {
            tableView.cellForRow(at: [0,i])?.accessoryType = .none
        }
    }
}

// MARK: - Table View Delegate
extension SettingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        
        switch source?.type {
        case .description:
            clearAccecoryType()
            cell?.accessoryType = .checkmark
            UserDefaults.standard.setValue(indexPath.row, forKey: source?.key?.rawValue ?? "")
        case .click:
            sender = indexPath.row
            performSegue(withIdentifier: "instructionSegue", sender: nil)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK: - Table View Datasource
extension SettingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source?.menu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "GitraSettingCell")
        cell.textLabel?.text = source?.menu?[indexPath.row]
        
        switch source?.type {
        case .description:
            if indexPath.row == source?.selected {
                cell.accessoryType = .checkmark
            }
        case .click:
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
}
