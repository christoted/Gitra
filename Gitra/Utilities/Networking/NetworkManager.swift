//
//  NetworkManager.swift
//  Gitra
//
//  Created by Christopher Teddy  on 07/06/21.
//

import Foundation

class NetworkManagerProtocol {
    
}

class NetworkManager {
    
    let BASE_URL = "https://api.uberchord.com/v1/chords/"
    
    func getSpecificChord(chord: String, completion: @escaping (ChordModel)->(), completionFailed: @escaping (Bool)->()) {
        
        let queryURL = BASE_URL + "\(chord)"
        let url = URL(string: queryURL)
        
        let request = URLRequest(url: url!)
        var chordModel = ChordModel()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse else {
                
                return
            }
          
            if let dataSave = data {
                if ( response.statusCode == 200) {
                    let decoder = JSONDecoder()
                    if let chordResponse = try?
                        decoder.decode([ChordResponse].self, from: dataSave) as [ChordResponse] {
                         
                        var chordModel = ChordModel()
                     
                        
                        chordResponse.forEach { (response)  in
                            chordModel.chordName = response.chordName
                            chordModel.enharmonicChordName = response.enharmonicChordName
                            chordModel.fingering = response.fingering
                            chordModel.strings = response.strings
                            chordModel.tones = response.tones
                            
                            completion(chordModel)
                        }
                        
                     //   completion(chordModel)
                        
                    } else {
                        print("ERROR CAN'T DECODE JSON")
                    }
                    
                } else {
                
                    print("Error \(response.statusCode)")
                    completionFailed(true)
                   
                }
            }
        
        }
        
        
        task.resume()
        
    }
    
}


