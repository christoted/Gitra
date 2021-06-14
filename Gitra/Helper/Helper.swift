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
        let symbols = ["b": ["flat", "b", "♭"],
                         "#": ["sharp", "#", "♯"]]
        let qualities = ["maj": ["major", "maj"],
                         "m": ["minor", "min"],
                         "add": ["add"],
                         "aug": ["aug", "augmented"],
                         "dim": ["dim", "diminished"],
                         "sus": ["sus", "suspended"]]
        let tensions = [2: ["2", "two"],
                        4: ["4", "four"],
                        5: ["5", "five", "fifth"],
                        6: ["6", "six", "sixth"],
                        7: ["7", "seven", "seventh"],
                        9: ["9", "nine", "ninth"],
                        11: ["11", "eleven"],
                        13: ["13", "thirteen"]]

        chord = chord.lowercased()

        let splitChordInput = chord.split {
            $0.isWhitespace
        }.map {
            String($0)
        }

        var output = splitChordInput[0]

        //Determine sharp & flat
        func checkRoots(_ text: String) -> String {
            for (notation, symbol) in symbols {
                for char in symbol {
                    if text.contains(char) {
                        return notation
                    }
                }
            }
            return ""
        }

        //Determine chord quality
        func checkQuality(_ text: String) -> String {
            for (notation, quality) in qualities {
                for char in quality {
                    if text.contains(char) {
                        return notation
                    }
                }
            }
            return ""
        }

        //Determine chord tension
        func checkTension(_ text: String) -> String {
            for (number, tension) in tensions {
                for char in tension {
                    if text.contains(char) {
                        return "\(number)"
                    }
                }
            }
            return ""
        }

        //Merging input
        for (index, text) in splitChordInput.enumerated() where index > 0 {
            if index == 1 && (checkRoots(text) != "") {
                output.append(checkRoots(text))
                output.append("_")
                continue
            } else if index == 1 && (checkRoots(text) == "") {
                output.append("_")
            } else if (index == 1 || index == 2) && checkQuality(text) == "major" {
                output.append("maj")
            }
            
            output.append(checkQuality(text))
            output.append(checkRoots(text))
            output.append(checkTension(text))
        }

        if output.contains("maj") && !output.contains("maj7") {
            output.removeLast(4)
        }
        
        output.capitalizeFirstLetter()
        
        return output
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
