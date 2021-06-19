//
//  ChordDetailViewController.swift
//  Gitra
//
//  Created by Christopher Teddy  on 07/06/21.
//

import UIKit

import Speech
import AVFoundation
import Lottie
import Foundation

class ChordDetailViewController: UIViewController {
    @IBOutlet var fretImage:UIImageView!
    @IBOutlet var startFret:UILabel!
    @IBOutlet var instructionLabel : UILabel!
    @IBOutlet var openCloseIndicators:UIView!
    @IBOutlet weak var commandLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    
    @IBOutlet weak var previousz: UIButton!
    @IBOutlet weak var nextz: UIButton!
    @IBOutlet weak var repeatz: UIButton!
    
    //Chord Model for param
    var chordModel:ChordModel?
    var resultTitle: String?
    var senderPage: ChordPickerViewController?
    
    var chordDelay: Double = 0.2
    var openIndicator:UIImage = #imageLiteral(resourceName: "O")
    var closeIndicator:UIImage = #imageLiteral(resourceName: "X")

    let animationView = AnimationView()
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask!

    @IBOutlet weak var lblCommand: UILabel!
    
    //Audio
    var player: AVAudioPlayer?
    
    //Timer
    var timer: Timer?
    
    let speechSynthesizer = AVSpeechSynthesizer()

    let speaker = Speaker()

    let queryChord = ChordResponse(
            strings: "X 3 2 0 1 0",
            fingering: "X 3 2 X 1 X",
            chordName: "C,,,",
            enharmonicChordName: "C,,,",
            voicingID: "9223372036855826559",
            tones: "C,E,G"
        )
    
    var countFinger = 0
    var strings = [0,0,0,0,0,0] //0 is open and -1 is dead
    var fingering = [0,0,0,0,0,0] //-1 means no fingers are there
    var labelForAccessibility = ["","","","","",""]
    var startingFret = 100 //initialize max value to compare
    var indicators:[FingerIndicator] = []
    
    var countFail:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        self.lottieAnimation2()
        setAlpha(isHide: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: { [self] in
            self.navigationSetup()
            guard let chordModelSave = chordModel else {
                return
            }
            self.translateToCoordinate(chord: chordModelSave)
            self.displayIndicators()
            self.generateStringForLabel()
            self.title = resultTitle
            UIView.animate(withDuration: 0.5) {
                self.setAlpha(isHide: false)
            }
            playChord(strings)

        //    next()

            
            let delay: DispatchTime = .now() + 6*chordDelay + 0.5
            
            DispatchQueue.main.asyncAfter(deadline: delay){
                next()
                print(delay)
            }

            animationView.stop()
            animationView.alpha = 0

        })
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = settingButton
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func lottieAnimation2(){
        UIView.animate(withDuration: 0.5) {
            self.animationView.alpha = 1
        }
        
        animationView.animation = Animation.named("loading-animation-1")
        animationView.frame = CGRect(x: self.view.frame.midX - 25, y: self.view.frame.midY * 0.75, width: 50, height: 50)
        animationView.contentMode = .scaleAspectFit
        animationView.isHidden = false
        animationView.loopMode = .loop
        animationView.play()
        view.insertSubview(animationView, aboveSubview: view)
    }
    
    private func setAlpha(isHide: Bool){
        if (isHide) {
            fretImage.alpha = 0
            startFret.alpha = 0
            instructionLabel.alpha = 0
            openCloseIndicators.alpha = 0
            commandLabel.alpha = 0
            lblCommand.alpha = 0
        } else {
            fretImage.alpha = 1
            startFret.alpha = 1
            instructionLabel.alpha = 1
            openCloseIndicators.alpha = 1
            commandLabel.alpha = 1
            lblCommand.alpha = 1
            
            
            
        }
      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
//        navigationSetup()
//        translateToCoordinate(chord:queryChord)
//        displayIndicators()
//        generateStringForLabel()
        

    }
    
    @objc func addTapped(){
        let pvc = UIStoryboard(name: "Setting", bundle: nil)
        let settingVC = pvc.instantiateViewController(withIdentifier: "setting")
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    
    //number of frets juga
    //open or dead
    var currString = -1
    func changeString(isNext: Int){
        var prev = 0
        if currString - 1 >= 0 {
            prev = indicators.count - currString - 1
        }else{
            prev = 5
        }
        indicators[prev].backgroundColor = UIColor.ColorLibrary.whiteAccent
        indicators[prev].setTitleColor(UIColor.ColorLibrary.blackAccent, for: .normal)
        
        if isNext == 1{
            currString = (currString + 1) % 6
            
            if (currString == 5) {
                print("lima")
                
            }
            
        }else if isNext == 2{
           currString = (currString - 1)
            if currString < 0{
                currString = 5
            }
        }else if isNext == 3 {
            
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
            labelForAccessibility[i] = guitarString((i+1)) + " String, "
            if strings[j] == -1{
                labelForAccessibility[i] += "muted."
            }
            else{
                if strings[j] == 0{
                    labelForAccessibility[i] += "open string. "
                }
                else if strings[j] > 0{
                    labelForAccessibility[i] += guitarFingering((fingering[j])) + " on "
                    labelForAccessibility[i] += "fret " + String(strings[j]) + ". "
                }
            }
            j-=1
            
        }
    }
    
    func navigationSetup(){
        //>>>:(
    }

    private func speechRecognitionActive() {
        
        self.playSound()
        lottieAnimation()
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        request = SFSpeechAudioBufferRecognitionRequest()
        guard request != nil else {
            fatalError("Unable to Create SFSpeech Object")
        }
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            alertView(message: "Error Start Audio Listener")
        }
        
        guard let myRecognization = SFSpeechRecognizer() else {
            self.alertView(message: "Recognization is now allow on your local")
            
            return
        }
        
        if !myRecognization.isAvailable {
            self.alertView(message: "Recognization is not available")
        }
        
        var isFinal = false
        
        task = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let resultCommand = result.bestTranscription.formattedString
                // Should I compare the result here to see if it changed?
                self.lblCommand.text = resultCommand
                isFinal = result.isFinal
                
            }
            
            if isFinal {
                
            } else if error == nil {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                    // Do whatever needs to be done when the timer expires
                    self.cancelSpeechRecognitization(resultCommand: self.lblCommand.text ?? "")
                    
                })
            }
        })
        
        if (task.isFinishing == true) {
            let lowerCased = self.lblCommand.text!.lowercased()
            
            if (lowerCased == "next") {
                print("Next")
            }
        }
    }
    
    private func cancelSpeechRecognitization(resultCommand: String) {
                
        if ( task != nil) {
            task.finish()
            task.cancel()
            task = nil
            
            self.hideAnimation()
            
            let lowerCased = resultCommand.lowercased()
            
            if (lowerCased == "next") {
                countFail = 0
                
                changeString(isNext: 1)
                speakInstruction()
               // print("Next bawah")
            } else if ( lowerCased == "previous") {
                countFail = 0
                
                changeString(isNext: 2)
                speakInstruction()
            } else if ( lowerCased == "repeat") {
                countFail = 0
                
                changeString(isNext: 3)
                speakInstruction()
            } else if ( lowerCased == "finish") {
                countFail = 0
                
                request.endAudio()
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
                
                //Sound Feedback On
                let speechUtterance = AVSpeechUtterance(string: "Congratulation You have Learn \(String(describing: self.title))")
            
                speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
                speechSynthesizer.speak(speechUtterance)
                
            } else if ( lowerCased == "start over") {
                currString = -1
                changeString(isNext: 1)
                speakInstruction()
                countFail = 0
            } else {
                //If the word is not match from the constraint above
                //Sound Feedback On
                
                if ( countFail < 2) {
                    let speechUtterance = AVSpeechUtterance(string: "Voice feedback is not available, please Input your voice again")

                    speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
                    speechSynthesizer.speak(speechUtterance)
                    countFail = countFail + 1
                    
                    self.timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { (timer) in
                        // Do whatever needs to be done when the timer expires
                        self.speechRecognitionActive()
                        self.lblCommand.text = "Listening..."
                        
                    })
              
                    print(countFail)
                } else {
                    let speechUtterance = AVSpeechUtterance(string: "Please use the button instead")

                    speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
                    speechSynthesizer.speak(speechUtterance)
                    
                    self.lblCommand.text = "Listening..."
                    
                    request.endAudio()
                    audioEngine.stop()
                    audioEngine.inputNode.removeTap(onBus: 0)
                }
                
            }
        }
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    private func lottieAnimation(){
        
        self.animationView.alpha = 1
        animationView.animation = Animation.named("loading-animation-1")
        animationView.frame = CGRect(x: self.view.frame.midX - 25, y: self.commandLabel.frame.maxY, width: 50, height: 50)
        animationView.isHidden = false
        animationView.loopMode = .loop
        animationView.play()
        view.insertSubview(animationView, belowSubview: self.fretImage)
       
    }
    
    private func hideAnimation() {
        animationView.isHidden = true
    }
    
    private func playSound() {
        guard let url = Bundle.main.path(forResource: "siri", ofType: "m4a") else {
            print("URL not found")
            return
        }
        
        do {
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            
            let backgroundMusic = NSURL(fileURLWithPath: url)
            
            player = try AVAudioPlayer(contentsOf: backgroundMusic as URL, fileTypeHint: AVFileType.m4a.rawValue)
            
            guard let player = player else {return}
            
            player.play()
            
        } catch let error {
            print("Error ", error.localizedDescription)
        }
    }

    //function to translate the strings from API into arrays (the 'strings' and 'fingering' array
    //it also determine the starting fret and how many indicator(s) are present in the diagram
    func translateToCoordinate(chord:ChordModel){
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
        
        if startingFret <= 2{
            startingFret = 1
        }
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
    
    func playChord(_ stringsArray: [Int]) {
        var note = [String]()
    
        let timeDelay = UserDefaults.standard.integer(forKey: "chordSpeed")
        
        switch timeDelay {
        case 0:
            chordDelay = 0.5
        case 1:
            chordDelay = 0.2
        case 2:
            chordDelay = 0.05
        default:
            break
        }
        
        for (index, frets) in stringsArray.enumerated() {
            if frets >= 0 {
                note.append(Database.shared.getGuitarNote((5 - index), frets))
            }
        }
        
       NotesMapping.shared.playSounds(note, withDelay: chordDelay)
    }
    
    func currentNote(_ senar: Int) -> String {
        let fret = strings[5-senar]
        if fret >= 0 {
            return Database.shared.getGuitarNote(senar, strings[(5 - senar)])
        }
        return ""
    }
    
    private func alertView(message: String) {
        let controller = UIAlertController.init(title: "Error ocured...!", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            controller.dismiss(animated: true, completion: nil)
        }))
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func guitarFingering(_ finger: Int) -> String {
        switch finger {
        case 1 :
            return "index finger"
        case 2 :
            return "middle finger"
        case 3 :
            return "ring finger"
        case 4 :
            return "pinky finger"
        default:
            return ""
        }
    }
    
    func guitarString(_ index: Int) -> String {
        switch index {
        case 1 :
            return "1st"
        case 2 :
            return "2nd"
        case 3 :
            return "3rd"
        default :
            return "\(index)th"
        }
    }
    
    @IBAction func previouszTapped(_ sender: UIBarButtonItem){
        changeString(isNext: 2)
        speakInstruction()
        countFail = 0
    }
    
    @IBAction func nextzTapped(_ sender: UIBarButtonItem){
        next()
        countFail = 0
    }
    
    func next() {
        changeString(isNext: 1)
        speakInstruction()
    }
    
    @IBAction func repeatzTapped(_ sender: UIBarButtonItem){
     //   speakInstruction()
        NotesMapping.shared.playSounds(["C3", "E3", "G3", "C4", "E4"])
    }
    
    func speakInstruction() {
        let tempString = currString
        speaker.stop()
        speaker.speak(instructionLabel.text!, playNote: currentNote(currString))
        
        let delay: DispatchTime = (currentNote(currString) == "") ? (.now() + 0) : (.now() + 3)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            //Check if user move to the next string before completing the instruction.
            if self.currString == tempString {
                self.speaker.speak(self.instructionLabel.text!, playNote: self.currentNote(self.currString))
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: delay + 5) {
            //Check if user move to the next string before completing the instruction.
            self.speechRecognitionActive()
            self.lblCommand.text = ""
        }
    }
}

class Speaker: NSObject {
    let synth = AVSpeechSynthesizer()
    var note = ""

    override init() {
        super.init()
        synth.delegate = self
    }
    
    func speak(_ str: String, playNote: String){
        let utterance = AVSpeechUtterance(string: str)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        synth.speak(utterance)
        note = playNote
    }
    
    func stop() {
        synth.stopSpeaking(at: .immediate)
    }
    

}

extension Speaker: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if note != "" {
            NotesMapping.shared.playSound(note)
        }
    }
}
