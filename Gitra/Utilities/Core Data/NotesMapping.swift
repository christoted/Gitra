//
//  NotesMapping.swift
//  Gitra
//
//  Created by Yahya Ayyash on 11/06/21.
//

import Foundation
import AVFoundation

class NotesMapping: NSObject, AVAudioPlayerDelegate {
    
    static let shared = NotesMapping()
    
    override init(){
    }
    
    var players = [NSURL:AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()
    
    func playSound (_ soundFileName: String) {
        let soundURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: soundFileName, ofType: "mp3")!)
        
        if let player = players[soundURL] {
            if !player.isPlaying {
                player.prepareToPlay()
                player.play()
            } else {
                let duplicatePlayer = try! AVAudioPlayer(contentsOf: soundURL as URL)
                duplicatePlayer.delegate = self
                duplicatePlayers.append(duplicatePlayer)
                
                duplicatePlayer.prepareToPlay()
                duplicatePlayer.play()
            }
        } else {
            do {
                let player = try AVAudioPlayer(contentsOf: soundURL as URL)
                players[soundURL] = player
                player.prepareToPlay()
                player.play()
            } catch {
                print("Couldn't play sound.")
            }
        }
    }
    
    func playSounds (_ soundFileNames: [String]) {
        for soundFileName in soundFileNames {
            playSound(soundFileName)
        }
    }
    
    func playSounds (_ soundFileNames: String...) {
        for soundFileName in soundFileNames {
            playSound(soundFileName)
        }
    }
    
    func playSounds (_ soundFileNames: [String], withDelay: Double) {
        for (index, soundFileName) in soundFileNames.enumerated() {
            let delay = withDelay*Double(index)
            let _ = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(playSoundNotification(_:)), userInfo: ["fileName": soundFileName], repeats: false)
        }
    }
    
    @objc func playSoundNotification(_ notification: NSNotification) {
        if let soundFileName = notification.userInfo?["fileName"] as? String {
            playSound(soundFileName)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        duplicatePlayers.remove(at: duplicatePlayers.firstIndex(of: player)!)
    }
}
