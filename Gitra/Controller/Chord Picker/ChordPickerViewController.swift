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
    
    let root = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    let quality = ["-","Major", "Minor", "Aug", "Dim"]
    let tension = ["-", "2", "4", "7", "9"]
    
    var chord: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        chooseButton.layer.cornerRadius = chooseButton.frame.height / 2
        
        chordPicker.dataSource = self
        chordPicker.delegate = self
                
        populateChord()
    }
    
    func populateChord(){
        chord.append(root)
        chord.append(quality)
        chord.append(tension)
    }
}

extension ChordPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return chord.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chord[component].count
    }
}

extension ChordPickerViewController: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return chord[component][row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.font = UIFont(name: "Product Sans Bold", size: 42)
        pickerLabel?.text = chord[component][row]

        let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.orange : UIColor.gray

        pickerLabel?.textColor = color

        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if chord[1][chordPicker.selectedRow(inComponent: 1)] == "Major" {
//            print("test")
//        }
        chordPicker.reloadAllComponents()
    }
}
