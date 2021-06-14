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
        guard amp > 0.05 else {
            return
        }
        
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
            try engine.start()
            tracker.start()
        } catch let err {
            Log(err)
        }
    }
    
    func stop() {
        engine.stop()
    }
}
