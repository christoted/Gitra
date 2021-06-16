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
        let value = defaults.object(forKey: "welcomeScreen")
        if (value as? Int == 0) && (value != nil){
            performSegue(withIdentifier: "skipOnboarding", sender: nil)
        } else {
            performSegue(withIdentifier: "toOnboarding", sender: nil)
        }
    }
}
