//
//  ChordPickerViewController.swift
//  Gitra
//
//  Created by Christopher Teddy  on 07/06/21.
//

import UIKit

class ChordPickerViewController: UIViewController {
    
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var chordPicker: UIPickerView!
    
    var note = Database.shared.getNote()
    var chord = Database.shared.getChord()
    
    var root = ""
    var quality = ""
    var tension = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        chooseButton.layer.cornerRadius = chooseButton.frame.height / 2
        
        chordPicker.dataSource = self
        chordPicker.delegate = self
        
        navigationItem.rightBarButtonItem?.accessibilityLabel = "Setting"
        updateUI()
    }
    
    @IBAction func chooseChord(_ sender: Any) {
        print(root + "_" + quality + "_" + tension)
    }
    
    func updateUI() {
        root = note[chordPicker.selectedRow(inComponent: 0)]
        quality = chord[chordPicker.selectedRow(inComponent: 1)].quality ?? ""
        tension = chord[chordPicker.selectedRow(inComponent: 1)].tension?[chordPicker.selectedRow(inComponent: 2)] ?? ""
        
        chooseButton.accessibilityLabel = selectedChordLabel()
    }
    
    func selectedChordLabel() -> String {
        let selectedChord = (transformChord(root) +  transformChord(quality) + transformChord(tension))
        
        return "Choose Chord, \(selectedChord)"
    }
    
    func transformChord(_ input: String) -> String {
        var output = input
        output = output.replacingOccurrences(of: "#", with: "Sharp")
        output = output.replacingOccurrences(of: "b", with: "Flat")
        
        switch output {
        case "-":
            output = ""
        case "Dim":
            output = "Diminished"
        case "Sus":
            output = "Suspended"
        case "Aug":
            output = "Augmented"
        default:
            break
        }
        return output
    }
}

extension ChordPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return note.count
        } else if component == 1 {
            return chord.count
        }
        let selectedRow = chordPicker.selectedRow(inComponent: 1)
        return chord[selectedRow].tension?.count ?? 1
    }
}

extension ChordPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.font = UIFont(name: "Product Sans Bold", size: 42)
        
        if component == 0 {
            pickerLabel?.text = note[row]
            pickerLabel?.accessibilityLabel = "Root, " + transformChord(note[row]) + "."
            pickerLabel?.accessibilityTraits = .adjustable
        }
        else if component == 1 {
            pickerLabel?.text = chord[row].quality
            pickerLabel?.accessibilityLabel = "Type, " + transformChord(chord[row].quality ?? "") + "."
            pickerLabel?.accessibilityTraits = .adjustable
        } else {
            let selectedRow = chordPicker.selectedRow(inComponent: 1)
            pickerLabel?.text = chord[selectedRow].tension?[row]
            pickerLabel?.accessibilityLabel = "Tension, " + transformChord(chord[selectedRow].tension?[row] ?? "") + "."
            pickerLabel?.accessibilityTraits = .adjustable
        }
        
        //        let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.orange : UIColor.gray
        //        pickerLabel?.textColor = color
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
}
