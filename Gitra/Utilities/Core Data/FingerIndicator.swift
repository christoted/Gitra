//
//  FingerIndicator.swift
//  Frets
//
//  Created by Adhella Subalie on 09/06/21.
//

import UIKit

class FingerIndicator: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    init(title: Int) {
        super.init(frame: .zero)
        backgroundColor = .white
        setTitle(String(title), for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        layer.masksToBounds = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
