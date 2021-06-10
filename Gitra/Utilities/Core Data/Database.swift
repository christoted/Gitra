//
//  Database.swift
//  Gitra
//
//  Created by Yahya Ayyash on 09/06/21.
//

import Foundation

class Database {
    
    static let shared = Database()
    
    private var noteList = [String]()
    private var chordList = [ChordQuality]()
    
    init(){
    }
    
    func seedNote() {
        noteList = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    }
    
    func seedChord() {
        chordList.append(ChordQuality(quality: "-", tension: ["-", "7", "7#5", "7b5", "7#9", "7b9", "9", "11", "13"]))
        chordList.append(ChordQuality(quality: "Major", tension: ["-", "6", "6/9", "7", "9", "11", "13"]))
        chordList.append(ChordQuality(quality: "Minor", tension: ["-", "6", "6/9", "7", "9", "11", "13"]))
        chordList.append(ChordQuality(quality: "Add", tension: ["9", "11"]))
        chordList.append(ChordQuality(quality: "Sus", tension: ["2", "4"]))
        chordList.append(ChordQuality(quality: "Dim", tension: ["-", "7"]))
        chordList.append(ChordQuality(quality: "Aug", tension: ["-", "7"]))
    }
    
    func seedData() {
        seedNote()
        seedChord()
    }
    
    func getNote() -> [String] {
        return noteList
    }
    
    func getChord() -> [ChordQuality] {
        return chordList
    }
}
