//
//  Helper.swift
//  Gitra
//
//  Created by Christopher Teddy  on 10/06/21.
//

import Foundation

class Helper {
    func convertStringToParam(chord: String) -> String {
        
        let roots = ["C", "D", "E", "F", "G", "A", "B"]
        let notations = ["flat", "b", "♭", "sharp", "#", "♯"]
        let qualities = ["major", "minor", "add", "aug", "augmented", "dim", "diminished", "sus", "suspended"]
        let tensions = ["two", "four", "five", "fifth", "six", "sixth", "seven", "seventh", "nine", "ninth", "eleven", "thirteen",
                       "2", "4", "5", "6", "7", "9", "11", "13"]
        
        let splitChordInput = chord.split {
            $0.isWhitespace
        }.map {
            String($0)
        }
        
        var chordToParam: String = splitChordInput[0]
        
        //contain major without tension
        for quality in qualities {
            
        }

        //contain major with tension
//        if ((chord.contains("major") || chord.contains("Major")) && (!chord.contains("six") || !chord.contains("seven") || !chord.contains("nine") || !chord.contains("eleven") || !chord.contains("thirteen") )) {
//            chordToParam.append("")
//        }
//
//        if ((chord.contains("major") || chord.contains("Major")) && (chord.contains("six") || chord.contains("seven") || chord.contains("nine") || chord.contains("eleven") || chord.contains("thirteen") )) {
//            chordToParam.append("_maj")
//        }
//
//        if (chord.contains("minor")) || chord.contains("Minor"){
//            chordToParam.append("_m")
//        }
//
//        if (chord.contains("add")) {
//            chordToParam.append("_add")
//        }
//
//        if (chord.contains("sus")) {
//            chordToParam.append("_sus")
//        }
//
//        if (chord.contains("dim")) {
//            chordToParam.append("_dim")
//        }
//
//        if (chord.contains("aug")) {
//            chordToParam.append("_aug")
//        }
//
//        if ( chord.contains("six") || chord.contains("6")) {
//            chordToParam.append("6")
//        }
//
//        if ( chord.contains("seven") || chord.contains("7")) {
//            chordToParam.append("7")
//        }
//
//        if ( chord.contains("nine") || chord.contains("9")) {
//            chordToParam.append("9")
//        }
//
//        if ( chord.contains("eleven") || chord.contains("11")) {
//            chordToParam.append("11")
//        }
//
//        if ( chord.contains("thirteen") || chord.contains("13")) {
//            chordToParam.append("13")
//        }
        
        return chordToParam
    }
}
