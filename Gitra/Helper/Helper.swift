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
}
