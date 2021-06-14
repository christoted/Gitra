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
        self.setTitleColor(UIColor.ColorLibrary.yellowAccent, for: .normal)
        self.setTitleColor(UIColor.ColorLibrary.yellowAccent.withAlphaComponent(0.5), for: .highlighted)
//        circleButton.layer.cornerRadius = circleButton.frame.width / 2
//                circleButton.layer.masksToBounds = true
        self.layer.cornerRadius = 15
    }
    
}
