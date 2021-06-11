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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ChordInputModeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chordInputMode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "CIMTableViewCell")
        cell.textLabel?.text = chordInputMode[indexPath.row].inputSettings
        return cell
    }
}
