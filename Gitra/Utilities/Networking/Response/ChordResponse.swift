//
//  ChordResponse.swift
//  Gitra
//
//  Created by Christopher Teddy  on 08/06/21.
//

import Foundation

struct ChordResponse: Codable {
    
    let strings: String?
    let fingering: String?
    let chordName: String?
    let enharmonicChordName: String?
    let voicingID: String?
    let tones: String?
    
    private enum CodingKeys: String, CodingKey {
        case strings = "strings"
        case fingering = "fingering"
        case chordName = "chordName"
        case enharmonicChordName = "enharmonicChordName"
        case voicingID = "voicingID"
        case tones = "tones"
    }
    
}


