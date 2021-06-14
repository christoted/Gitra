//
//  AutomaticTunerViewController.swift
//  Gitra
//
//  Created by Yahya Ayyash on 13/06/21.
//

import UIKit

class AutomaticTunerViewController: UIViewController, TunerDelegate {

    @IBOutlet var strings: [UIButton]!
    @IBOutlet weak var viewIndicator: UIView!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var conductor = TunerConductor()
    var indicatorCircle: CAShapeLayer?
    var start = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conductor.delegate = self
        
        //Set button tag and style
        for (index, button) in strings.enumerated() {
            button.tag = index
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.masksToBounds = true
        }
        
        let backgroundCircle = CAShapeLayer()
        backgroundCircle.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: viewIndicator.frame.width, height: viewIndicator.frame.height)).cgPath
        backgroundCircle.fillColor = UIColor.ColorLibrary.whiteAccent.cgColor

        indicatorCircle = backgroundCircle
        indicatorCircle?.fillColor = UIColor.ColorLibrary.yellowAccent.cgColor
        
        viewIndicator.layer.addSublayer(indicatorCircle!)
        viewIndicator.layer.addSublayer(backgroundCircle)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.conductor.stop()
    }
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        
        //Start tuner on button press
        if !start {
            self.conductor.start()
            start = true
        }
        
        //Set button color on the stack view
        strings.forEach({$0.backgroundColor = .ColorLibrary.whiteAccent})
        
        let setFrequency = NoteFrequency.allCases[sender.tag]
        conductor.noteFrequency = setFrequency.rawValue
        sender.backgroundColor = .ColorLibrary.yellowAccent
    }
    
    func tunerDidMeasure(pitch: Float, amplitude: Float, target: Float) {
 
        let freqGap: Float = pitch - target
        let errorDiff: Float = target * 0.5
        let frame = self.view.frame.width / 2
        var position = CGPoint()
        
        if abs(freqGap) < errorDiff { //Target note is pretty close
            let mappedPos = map(minRange: Int(target - errorDiff), maxRange: Int(target + errorDiff), minDomain: Int(-frame), maxDomain: Int(frame), value: Int(pitch))
            position = CGPoint(x: mappedPos, y: 0)
            
            if abs(freqGap) < target * 0.003 {
                indicatorCircle?.fillColor = UIColor.systemGreen.cgColor
                statusLabel.text = "You're in tune!"
            } else {
                statusLabel.text = freqGap > 0 ? "Too sharp, tune down." : "Too flat, tune up."
                indicatorCircle?.fillColor = UIColor.ColorLibrary.yellowAccent.cgColor
            }
        } else { //Target note is much lower or larger
            indicatorCircle?.fillColor = UIColor.ColorLibrary.orangeAccent.cgColor
            if freqGap > 0 {
                position = CGPoint(x: frame, y: 0)
            }
            
            if freqGap < 0 {
                position = CGPoint(x: -frame, y: 0)
            }
            statusLabel.text = freqGap > 0 ? "Too sharp, tune down." : "Too flat, tune up."
        }
        
        indicatorCircle?.position = position
    }
    
    func map(minRange: Int, maxRange: Int, minDomain: Int, maxDomain: Int, value: Int) -> Int {
        return minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    }
}
