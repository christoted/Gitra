//
//  SoundHelpe.swift
//  Gitra
//
//  Created by Christopher Teddy  on 10/06/21.
//

import Foundation
import AVFoundation

class SoundHelper {
    
    var audioPlayer: AVAudioPlayer?
    
    func startMusic(filename: String) {
        if let bundle = Bundle.main.path(forResource: filename, ofType: "m4a") {
            let music = NSURL(fileURLWithPath: bundle)
            
            do {
                
                audioPlayer = try
                AVAudioPlayer(contentsOf: music as URL)
                
                guard let audioPlayer = audioPlayer else {return}
                
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
}
