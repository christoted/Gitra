//
//  SelectorViewController.swift
//  Gitra
//
//  Created by Yahya Ayyash on 17/06/21.
//

import UIKit

class SelectorViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if OnboardingHandler.shared.isFirstLaunch {
            defaults.set(0, forKey: "inputMode")
            defaults.set(1, forKey: "welcomeScreen")
            defaults.set(1, forKey: "inputCommand")
            defaults.set(1, forKey: "chordSpeed")
            OnboardingHandler.shared.isFirstLaunch = true
        }
        
        let value = defaults.integer(forKey: "welcomeScreen")
        if (value == 0) {
            performSegue(withIdentifier: "skipOnboarding", sender: nil)
        } else {
            performSegue(withIdentifier: "toOnboarding", sender: nil)
        }
    }
}
