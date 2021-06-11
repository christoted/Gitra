//
//  TestViewController.swift
//  Gitra
//
//  Created by Yahya Ayyash on 10/06/21.
//

import UIKit
import AVFoundation

class TestViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButton2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }
    
    @IBAction func playGuitarNote(_ sender: Any) {
        let note = ["E2", "B2", "E3", "G#3", "B3", "E4"]
        let delay = 0.1
        NotesMapping.shared.playSounds(note, withDelay: delay)
    }
    
    @IBAction func playGuitarNote2(_ sender: Any) {
        let note = ["E2", "B2", "E3", "G#3", "B3", "E4"]
        let delay = 1.0
        NotesMapping.shared.playSounds(note, withDelay: delay)
    }
    
}
