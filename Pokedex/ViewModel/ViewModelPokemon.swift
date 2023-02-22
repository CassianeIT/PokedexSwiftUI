//
//  ViewModelPokemon.swift
//  Pokedex
//
//  Created by Cassiane Freitas on 11/01/23.
//

import Foundation
import SwiftUI
import UIKit
class ViewModelPokemon: ObservableObject {
    @Published var pokemonDetail = [PokemonDetail]()

    func fetchDetails(pokemonName: String, onSuccess: @escaping(Bool) -> Void ) {
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonName)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error has occured: \(error.localizedDescription)")
                
            } else if let data = data {
                do {
                    let jsonModel = try JSONDecoder().decode(PokemonDetail.self, from: data)
                  
                    DispatchQueue.main.async { [self] in
                        self.pokemonDetail = [jsonModel]
                    
                        onSuccess(true)
                    }
                } catch  {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
}
