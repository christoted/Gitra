//
//  NetworkManager.swift
//  Gitra
//
//  Created by Christopher Teddy  on 07/06/21.
//

import Foundation

class NetworkManager {
    
    let BASE_URL = "https://api.uberchord.com/v1/"
    
    func getSpecificChord(chord: String) {
        
        var components = URLComponents(string: BASE_URL)
        
        
        let request = URLRequest(url: components?.url)
        
    }
    
}


