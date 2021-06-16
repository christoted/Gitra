//
//  ChordDetailViewController.swift
//  Gitra
//
//  Created by Christopher Teddy  on 07/06/21.
//

import UIKit
import AVFoundation

class ChordDetailViewController: UIViewController {
    @IBOutlet var fretImage:UIImageView!
    @IBOutlet var startFret:UILabel!
    @IBOutlet var instructionLabel : UILabel!
    @IBOutlet var openCloseIndicators:UIView!
        
    @IBOutlet weak var previousz: UIBarButtonItem!
    @IBOutlet weak var nextz: UIBarButtonItem!
    @IBOutlet weak var repeatz: UIBarButtonItem!
    
    var openIndicator:UIImage = #imageLiteral(resourceName: "O")
    var closeIndicator:UIImage = #imageLiteral(resourceName: "X")

    
    let queryChord = ChordResponse(
            strings: "X 3 2 0 1 0",
            fingering: "X 3 2 X 1 X",
            chordName: "C,,,",
            enharmonicChordName: "C,,,",
            voicingID: "9223372036855826559",
            tones: "C,E,G"
        )
//    let queryChord = ChordResponse(
//            strings: "7 9 9 8 7 7",
//            fingering: "1 3 4 2 1 1",
//            chordName: "C,,,",
//            enharmonicChordName: "C,,,",
//            voicingID: "9223372036855826559",
//            tones: "C,E,G"
//        )
    
    var countFinger = 0
    var strings = [0,0,0,0,0,0] //0 is open and -1 is dead
    var fingering = [0,0,0,0,0,0] //-1 means no fingers are there
    var labelForAccessibility = ["","","","","",""]
    var startingFret = 100 //initialize max value to compare
    var indicators:[FingerIndicator] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetup()
        translateToCoordinate(chord:queryChord)
        displayIndicators()
        generateStringForLabel()
        
        repeatz.accessibilityLabel = "Repeat"
    }
    //number of frets juga
    //open or dead
    
    var currString = -1
    func changeString(isNext:Bool){
        var prev = 0
        if currString - 1 >= 0 {
            prev = indicators.count - currString - 1
        }else{
            prev = 5
        }
        indicators[prev].backgroundColor = UIColor.ColorLibrary.whiteAccent
        indicators[prev].setTitleColor(UIColor.ColorLibrary.blackAccent, for: .normal)
        
        if isNext{
            currString = (currString + 1) % 6
        }else{
            currString = (currString - 1)
            if currString < 0{
                currString = 5
            }
        }
        instructionLabel.text = labelForAccessibility[currString]
        let imageName = "FretsGlow-" + String(currString + 1)
        fretImage.image = UIImage(named: imageName)
        indicators[indicators.count - 1 - currString].backgroundColor = UIColor.ColorLibrary.orangeAccent
        indicators[indicators.count - 1 - currString].setTitleColor(UIColor.ColorLibrary.whiteAccent, for: .normal)
    }
    
    func generateStringForLabel(){ //Jari, Senar, Fret
        var j = 5
        for i in (0...5){
            labelForAccessibility[i] = "String " + String(i+1) + ", "
            if strings[j] == -1{
                labelForAccessibility[i] += "Mute. "
            }
            else{
                if strings[j] == 0{
                    labelForAccessibility[i] += "Open String. "
                }
                else if strings[j] > 0{
                    labelForAccessibility[i] += "Finger " + String(fingering[j]) + ", "
                    labelForAccessibility[i] += "Fret " + String(strings[j]) + ". "
                }
            }
            j-=1
        }
    }
    
    func navigationSetup(){
        //>>>:(
    }
    
    
    //function to translate the strings from API into arrays (the 'strings' and 'fingering' array
    //it also determine the starting fret and how many indicator(s) are present in the diagram
    func translateToCoordinate(chord:ChordResponse){
        guard let s = chord.strings else {return}
        let stringsComponents = s.split{ $0.isWhitespace }.map { String($0) }
        guard let f = chord.fingering else {return}
        let fingeringComponents = f.split{ $0.isWhitespace }.map { String($0) }
        
        for i in 0..<stringsComponents.count{
            if stringsComponents[i] != "X"{
                let fret = Int(stringsComponents[i])!
                
                strings[i] = fret
                if(fret < startingFret && fret > 0){ //this determines the starting point by assesing the minimal fret value
                    startingFret = fret
                }
                if(fret>0){ //counting which indicator is going to be present
                    countFinger += 1
                }
            }else{ //if the component is X
                strings[i] = -1
            }
            
            if fingeringComponents[i] != "X"{
                fingering[i] = Int(fingeringComponents[i])!
            }else{ //if the component is X
                fingering[i] = -1
            }
        }
    }
    
    func callBabangVoiceOver(message: String){
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    func playAudioAfterVoiceOver(){
        let currentStrings = currString
        let currentFret = strings[currentStrings]
        print(currentStrings)
        print(currentFret)
        let nada = Database.shared.getGuitarNote(currentStrings, currentFret)
        NotesMapping.shared.playSound(nada)
    }
    
    func displayIndicators(){
        let fretWidth = fretImage.frame.width
        let fretHeight = fretImage.frame.height
        
        let size = CGFloat(fretWidth * 2/27)
//        let leading = CGFloat(1 / 27 * fretWidth)
        let top = 1 / 41 * fretHeight
        let betweenString = CGFloat((25 / 27 * fretWidth) / 5)
        let betweenFret = CGFloat((fretHeight - top) / 5)
        
        for i in 0..<strings.count{
                    let indicator: FingerIndicator = {
                        let button = FingerIndicator(title: fingering[i])
                        return button
                    }()
                    if fingering[i]>0{ //check if there's an indicator or not
                        fretImage.addSubview(indicator)
                        indicator.layer.cornerRadius = size/2
                        indicator.frame = CGRect(x: CGFloat((CGFloat(i) * betweenString)), y:  CGFloat(4 * top + (CGFloat(strings[i]-startingFret) * betweenFret)), width: size, height: size)
                    }
                    indicators.append(indicator)
                }
        startFret.text = String(startingFret - 1)
        
        for i in 0..<strings.count{
            if strings[i] > 0{
                continue
            }else{
                let xPosition = CGFloat(i) * betweenString
                let yPosition = CGFloat(0)
                
                let stringIndicator = UIImageView(frame: CGRect(x: xPosition, y: yPosition, width: size, height: size))
                
                if strings[i] == 0{
                    stringIndicator.image = openIndicator
                }else{
                    stringIndicator.image = closeIndicator
                }
                
                openCloseIndicators.addSubview(stringIndicator)
                
            }
        }
    }
    
    @IBAction func previouszTapped(_ sender: UIBarButtonItem){
        changeString(isNext: false)
        if (UIAccessibility.isVoiceOverRunning) {
            let message: NSAttributedString = NSAttributedString(string: instructionLabel.text!, attributes: [.accessibilitySpeechQueueAnnouncement: true])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                UIAccessibility.post(notification: .announcement, argument: message)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.playAudioAfterVoiceOver()
        }
    }
    @IBAction func nextzTapped(_ sender: UIBarButtonItem){
        changeString(isNext: true)
        if (UIAccessibility.isVoiceOverRunning) {
            let message: NSAttributedString = NSAttributedString(string: instructionLabel.text!, attributes: [.accessibilitySpeechQueueAnnouncement: true])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                UIAccessibility.post(notification: .announcement, argument: message)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.playAudioAfterVoiceOver()
        }
    }
    @IBAction func repeatzTapped(_ sender: UIBarButtonItem){
        if (UIAccessibility.isVoiceOverRunning) {
            let message: NSAttributedString = NSAttributedString(string: instructionLabel.text!, attributes: [.accessibilitySpeechQueueAnnouncement: true])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                UIAccessibility.post(notification: .announcement, argument: message)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.playAudioAfterVoiceOver()
        }
    }
    
    
}
