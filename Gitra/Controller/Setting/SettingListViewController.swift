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
        destination?.source = self.sender
    }
    
    func setupUI() {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // TODO: Move to ViewModel (?)
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
        // Deselect all row to remove checkmark
        for i in 0..<(source?.child?.count ?? 0) {
            tableView.cellForRow(at: [0,i])?.accessoryType = .none
        }
    }
}

// MARK: - TableView Delegate
extension SettingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        
        switch source?.type {
        case .options:
            clearAccecoryType()
            cell?.accessoryType = .checkmark
            
            // TODO: Move to ViewModel (?)
            UserDefaults.standard.setValue(indexPath.row, forKey: source?.key?.rawValue ?? "")
        case .disclosure:
            sender = indexPath.row
            // TODO: Store identifier in enum
            performSegue(withIdentifier: "instructionSegue", sender: nil)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK: - TableView Datasource
extension SettingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Handle Optional & nil coalescing, make it cleaner
        return source?.child?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Store identifier in enum
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "GitraSettingCell")
        cell.textLabel?.text = source?.child?[indexPath.row].title
        
        switch source?.type {
        case .options:
            if indexPath.row == source?.value { cell.accessoryType = .checkmark }
        case .disclosure:
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
}
