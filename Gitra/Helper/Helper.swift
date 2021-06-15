//
//  Helper.swift
//  Gitra
//
//  Created by Christopher Teddy  on 10/06/21.
//

import Foundation

class Helper {
    func convertStringToParam(chord: String)->String {
        

        let splitChordInput = chord.split {
            $0.isWhitespace
        }.map {
            String($0)
        }
        
        var chordToParam:String = splitChordInput[0]
        
        if (chord.contains("major") && (!chord.contains("six") || !chord.contains("seven") || !chord.contains("nine") || !chord.contains("eleven") || !chord.contains("thirteen") )) {
            chordToParam.append("")
        }

        if (chord.contains("major") && (chord.contains("six") || chord.contains("seven") || chord.contains("nine") || chord.contains("eleven") || chord.contains("thirteen") )) {
            chordToParam.append("_maj")
        }

        if (chord.contains("minor")) {
            chordToParam.append("_m")
        }

        if (chord.contains("add")) {
            chordToParam.append("_add")
        }

        if (chord.contains("sus")) {
            chordToParam.append("_sus")
        }

        if (chord.contains("dim")) {
            chordToParam.append("_dim")
        }

        if (chord.contains("aug")) {
            chordToParam.append("_aug")
        }

        if ( chord.contains("six")) {
            chordToParam.append("6")
        }

        if ( chord.contains("seven")) {
            chordToParam.append("7")
        }

        if ( chord.contains("nine")) {
            chordToParam.append("9")
        }

        if ( chord.contains("eleven")) {
            chordToParam.append("11")
        }

        if ( chord.contains("thirteen")) {
            chordToParam.append("13")
        }
        
        
        return chordToParam
    }
    
    func checkSpeelString(firstString: String, secondString: String, thirdString: String) -> Bool {
        
        let bankChord = ["C", "D", "E", "F", "G", "A", "B"]
        let bankQuality = ["major", "minor", "add", "sus", "dim", "sus", "aug"]
        let bankNumber = ["seven", "six", "nine", "eleven", "thirteen"]
        
        
        var isValid = false
        var isValidChord = false
        var isValidQuality = false
        var isValidNumber = false
        
        bankChord.forEach { (str) in
            if ( !firstString.contains(str)) {
                isValidChord = false
            } else if (firstString.contains(str)) {
                isValidChord = true
            }
        }
        
        bankQuality.forEach { (str) in
            if ( !secondString.contains(str)) {
                isValidQuality = false
            } else if (secondString.contains(str)) {
                isValidQuality = true
            }
        }
        
        if ( thirdString.count == 0) {
            isValidNumber = true
        } else if ( thirdString.count != 0) {
            bankNumber.forEach { (str) in
                if ( !thirdString.contains(str)) {
                    isValidNumber = false
                } else if (thirdString.contains(str)) {
                    isValidNumber = true
                }
            }
            
        }
        
        
        
        if ( isValidChord == true && isValidNumber == true && isValidQuality == true) {
            isValid = true
        }
        
        return isValidChord
    }
    
}
