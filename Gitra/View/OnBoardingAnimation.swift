//
//  OnBoardingAnimation.swift
//  Gitra
//
//  Created by Samuel Maynard on 08/06/21.
//

import UIKit
import AVFoundation

class OnBoardingAnimation: UIViewController{
    
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var gitra: UILabel!
    
    
    @IBOutlet weak var sentence1 : UILabel!
    @IBOutlet weak var sentence2 : UILabel!
    @IBOutlet weak var sentence3 : UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let speechSynthesizer = AVSpeechSynthesizer()
        //        let speechUtterance = AVSpeechUtterance(string: welcome.text! + gitra.text! + " " + sentence1.text! + "  " + sentence2.text! + "  " + sentence3.text!)
        //
        //
        //
        //
        //        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        //        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        //        speechSynthesizer.speak(speechUtterance)
        
        
        //        UIView.transition(with: sentence1, duration: 3, animations: {
        //            self.sentence1.alpha = 1
        //        }, completion: {_ in
        //            UIView.transition(with: self.sentence2, duration: 4, animations: {
        //                self.sentence2.alpha = 1
        //            }, completion: {_ in
        //                UIView.transition(with: self.sentence3, duration: 2.5, animations: {
        //                    self.sentence3.alpha = 1
        //                })
        //
        //
        //            })
        //        })
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 13) {
        //            self.performSegue(withIdentifier: "seguetochord", sender: nil)
    }
    
    @IBAction func buttonDidTapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "seguetochord", sender: nil)
    }
    
    
    
    
    
    
    //    }
    
}
