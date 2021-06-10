//
//  ChordVoiceViewController.swift
//  Gitra
//
//  Created by Christopher Teddy  on 07/06/21.
//

import UIKit
import Speech
import Lottie
import AVFoundation

class ChordVoiceViewController: UIViewController {
    
    @IBOutlet weak var imageTap: UIImageView!
    @IBOutlet weak var lblResult: UILabel!
    
    @IBOutlet weak var lblWhich: UILabel!
    
    //MARK: - Local Properties
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask!
    var isStart: Bool = false
    
    let animationView = AnimationView()
    
    //Timer
    var timer: Timer?
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let speechUtterance = AVSpeechUtterance(string: lblWhich.text!)
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechUtterance.rate = 0.5
        speechSynthesizer.speak(speechUtterance)
        
        
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageTap.isUserInteractionEnabled = true
        imageTap.addGestureRecognizer(tapGestureRecognizer)
        
        requestPermission()
        
      //  hideAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.lottieAnimation()
            self.isStart = true
            self.speechRecognitionActive()
        }
        
    }
    
    private func lottieAnimation(){
        animationView.animation = Animation.named("audio")
        animationView.frame = view.bounds
        animationView.isHidden = false
        animationView.loopMode = .loop
        animationView.play()
      //  view.addSubview(animationView)
        view.insertSubview(animationView, belowSubview: imageTap)
    }
    
    private func hideAnimation() {
        animationView.isHidden = true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        isStart = !isStart
        
        if (isStart) {
            lottieAnimation()
            speechRecognitionActive()
            
        } else {
            cancelSpeechRecognitization()
            hideAnimation()
        }
    
    }
    
    private func speechRecognitionActive() {
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
        } catch let error {
            alertView(message: "Error Start Audio Listener")
        }
        
        guard let myRecognization = SFSpeechRecognizer() else {
            self.alertView(message: "Recognization is now allow on your local")
            
            return
        }
        
        if !myRecognization.isAvailable {
            self.alertView(message: "Recognization is not available")
        }
        
        task = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            
//
//
//            guard let response = response else {
//
//                if ( error != nil) {
//                    self.alertView(message: error.debugDescription)
//                } else {
//                    self.alertView(message: "Problem in giving response")
//                }
//
//                return
//            }
//
//
//            let message = response.bestTranscription.formattedString
//
//            self.lblResult.text = message
            
            var isFinal = false

            if let result = result {
                self.lblResult.text = result.bestTranscription.formattedString
                // Should I compare the result here to see if it changed?
                isFinal = result.isFinal
            }

            if isFinal {
              //  self.cancelSpeechRecognitization()
//                self.restartSpeechTimer()
//                print("ISFinal")
            }
            else if error == nil {
                self.timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false, block: { (timer) in
                    // Do whatever needs to be done when the timer expires
                    self.cancelSpeechRecognitization()
                    self.animationView.isHidden = true

                })
                

                
            }

           
            
        })
        
        
        if ( task.isFinishing == true) {
            let speechUtterance = AVSpeechUtterance(string: self.lblResult.text!)
        
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
            speechSynthesizer.speak(speechUtterance)
        }
    }
    
    private func restartSpeechTimer() {
        
      //  self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            // Do whatever needs to be done when the timer expires
            self.cancelSpeechRecognitization()
            print("After 1,5 second end, STOP")
        })
    }
    
   
    
    
    private func cancelSpeechRecognitization() {
        
        if ( task != nil) {
            task.finish()
            task.cancel()
            task = nil
            
            let speechUtterance = AVSpeechUtterance(string: self.lblResult.text!)
        
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
            speechSynthesizer.speak(speechUtterance)
            
        }
        
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    private func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { (authState) in
            OperationQueue.main.addOperation {
                if authState == .authorized {
                    print("Accepted")
                } else if authState == .denied {
                    self.alertView(message: "Denied")
                } else if ( authState == .notDetermined) {
                    self.alertView(message: "In User phone There's no Speech Recog")
                } else if authState == .restricted {
                    self.alertView(message: "Restricted")
                }
            }
        }
    }
    
    private func alertView(message: String) {
        let controller = UIAlertController.init(title: "Error ocured...!", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            controller.dismiss(animated: true, completion: nil)
        }))
        
        self.present(controller, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
