//
//  RoundedButton.swift
//  Gitra
//
//  Created by Rafi Zhafransyah on 14/06/21.
//

import UIKit

class RoundedButton: UIButton {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        self.layer.cornerRadius = 15
    }
}
