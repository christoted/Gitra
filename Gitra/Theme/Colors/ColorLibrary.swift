//
//  ColorLibrary.swift
//  Gitra
//
//  Created by Rafi Zhafransyah on 10/06/21.
//

import UIKit

extension UIColor {
    struct ColorLibrary {
        static var blackAccent: UIColor{ return UIColor(named: "Black Background") ?? UIColor.clear }
        static var whiteAccent: UIColor{ return UIColor(named: "White Background") ?? UIColor.clear }
        static var yellowAccent: UIColor{ return UIColor(named: "Yellow Accent") ?? UIColor.clear }
        static var redAccent: UIColor{ return UIColor(named: "Red Accent") ?? UIColor.clear }
        static var orangeAccent: UIColor{ return UIColor(named: "Orange Accent") ?? UIColor.clear }
    }
}
