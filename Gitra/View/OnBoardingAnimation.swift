//
//  OnBoardingAnimation.swift
//  Gitra
//
//  Created by Samuel Maynard on 08/06/21.
//

import UIKit
import AVFoundation

class OnBoardingAnimation: UIViewController{
    
    @IBOutlet weak var sentence1 : UILabel!
    @IBOutlet weak var sentence2 : UILabel!
    @IBOutlet weak var sentence3 : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: sentence1.text! + "  " + sentence2.text! + "  " + sentence3.text!)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechSynthesizer.speak(speechUtterance)
        
        
        
        UIView.transition(with: sentence1, duration: 2.5, animations: {
            self.sentence1.alpha = 1
        }, completion: {_ in
            UIView.transition(with: self.sentence2, duration: 3.5, animations: {
                self.sentence2.alpha = 1
            }, completion: {_ in
                UIView.transition(with: self.sentence3, duration: 2, animations: {
                    self.sentence3.alpha = 1
                })
            })
        })

    }
    
}
