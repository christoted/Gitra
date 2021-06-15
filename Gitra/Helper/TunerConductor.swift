//
//  TunerConductor.swift
//  Gitra
//
//  Created by Yahya Ayyash on 14/06/21.
//

import UIKit
import AudioKit
import AudioToolbox
import AudioKitEX
import SoundpipeAudioKit

protocol TunerDelegate {
    func tunerDidMeasure(pitch: Float, amplitude: Float, target: Float)
}

class TunerConductor {
    
    var delegate: TunerDelegate?
    
    private var engine = AudioEngine()
    private var mic: AudioEngine.InputNode
    private var tappableNode1 : Fader
    private var tappableNode2 : Fader
    private var tappableNode3 : Fader
    private var tappableNodeA : Fader
    private var tappableNodeB : Fader
    private var tappableNodeC : Fader
    private var tracker: PitchTap!
    private var silence: Fader
    private var data = TunerData()
    
    var noteFrequency: Float = 0.0
    
    func update(_ pitch: AUValue, _ amp: AUValue) {
        
        //Noise filtering
        guard amp > 0.1 else {
            return
        }
        
        detectFrequencies(pitch)
        self.delegate?.tunerDidMeasure(pitch: pitch, amplitude: amp, target: noteFrequency)
    }
    
    init() {
        guard let input = engine.input else {
            fatalError()
        }
        
        mic = input
        tappableNode1 = Fader(mic)
        tappableNode2 = Fader(tappableNode1)
        tappableNode3 = Fader(tappableNode2)
        tappableNodeA = Fader(tappableNode3)
        tappableNodeB = Fader(tappableNodeA)
        tappableNodeC = Fader(tappableNodeB)
        silence = Fader(tappableNodeC, gain: 0)
        engine.output = silence
        
        tracker = PitchTap(mic) { pitch, amp in
            DispatchQueue.main.async {
                self.update(pitch[0], amp[0])
            }
        }
    }
    
    func start() {
        do {
            let filter = LowPassFilter(silence)
            filter.cutoffFrequency = 6_900 //Hz
            filter.resonance = 0 //dB
            try engine.start()
            try Settings.setSession(category: .playAndRecord, with: [.defaultToSpeaker, .allowBluetooth])
            tracker.start()
        } catch let err {
            Log(err)
        }
    }
    
    func stop() {
        engine.stop()
    }
    
    //Automatic note detection
    func detectFrequencies(_ pitch: AUValue) {
        
        if (pitch > 284.92) && (pitch < 369.99) { //1st String - E4
            noteFrequency = NoteFrequency.string1.rawValue
        } else if (pitch > 220) && (pitch < 284.92) { //2nd String - B3
            noteFrequency = NoteFrequency.string2.rawValue
        } else if (pitch > 169.71) && (pitch < 220) { //3rd String - G3
            noteFrequency = NoteFrequency.string3.rawValue
        } else if (pitch > 127.14) && (pitch < 169.71) { //4th String - D3
            noteFrequency = NoteFrequency.string4.rawValue
        } else if (pitch > 95.25) && (pitch < 127.14) { //5th String - A3
            noteFrequency = NoteFrequency.string5.rawValue
        } else if (pitch > 73.42) && (pitch < 95.25) { //6th String - E2
            noteFrequency = NoteFrequency.string6.rawValue
        }
    }
}
