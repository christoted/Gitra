//
//  ChordInputSpeedViewController.swift
//  Gitra
//
//  Created by Gilang Adrian on 10/06/21.
//

import UIKit

enum input{
    case voiceCommand
    case picker
}

struct inputMode{
    var inputSettings : String
    var type : input
}

class ChordInputModeViewController: UIViewController{
    
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    var chordInputMode = [inputMode(inputSettings: "Voice Command", type: .voiceCommand),
                          inputMode(inputSettings: "Picker", type: .picker)]

}

extension ChordInputModeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.cellForRow(at: [0,0])?.accessoryType = .none
        tableView.cellForRow(at: [0,1])?.accessoryType = .none
        let cell = tableView.cellForRow(at: indexPath)
        
        //tableView.deselectRow(at: indexPath, animated: false)
        cell?.accessoryType = .checkmark
        UserDefaults.standard.setValue(indexPath.row, forKey: "inputMode")
        
    }
//    //baru
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.accessoryType = .checkmark
//        return indexPath
//    }
//
//    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.accessoryType = .none
//        return indexPath
//    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}

extension ChordInputModeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chordInputMode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "CIMTableViewCell")
        cell.selectionStyle = .none
        cell.textLabel?.text = chordInputMode[indexPath.row].inputSettings
//        if (cell.textLabel?.text)! == chordInputMode[UserDefaults.standard.integer(forKey: "inputMode")].inputSettings{
//            cell.setSelected(true, animated: true   )
//        }
        if (indexPath.row) == UserDefaults.standard.integer(forKey: "inputMode"){
//  buat nyala2          tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
            cell.accessoryType = .checkmark
        }
        
        return cell
    }

}
