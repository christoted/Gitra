//
//  ChordSpeedViewController.swift
//  Gitra
//
//  Created by Gilang Adrian on 10/06/21.
//

import UIKit

enum speed{
    case slow
    case normal
    case fast
}

struct kecepatan{
    var speedSettings : String
    var type : speed
}

class ChordSpeedViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    var orangTua: SettingViewController?
    
    enum destination{
        case speed
        case chordInput
        case asdsa
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        orangTua?.tableView.reloadData()
        
    }

    var chordSpeed = [kecepatan(speedSettings: "Slow", type: .slow),
                    kecepatan(speedSettings: "Normal", type: .normal),
                    kecepatan(speedSettings: "Fast", type: .fast)]
                
}

extension ChordSpeedViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: [0,0])?.accessoryType = .none
        tableView.cellForRow(at: [0,1])?.accessoryType = .none
        tableView.cellForRow(at: [0,2])?.accessoryType = .none
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        UserDefaults.standard.setValue(indexPath.row, forKey: "chordSpeed")
        //orangTua?.tableView.reloadData()

        //SettingViewController().refresh()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
}

extension ChordSpeedViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chordSpeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "ChordSpeedTableViewCell")
        cell.selectionStyle = .none
        cell.textLabel?.text = chordSpeed[indexPath.row].speedSettings
        
        if (indexPath.row) == UserDefaults.standard.integer(forKey: "chordSpeed"){
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
}
