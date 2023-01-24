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
    @Published var aboutPokemonViewColorBackground: UIColor = .white

    func fetchDetails(pokemonName: String) {
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonName)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error has occured: \(error.localizedDescription)")
                
            } else if let data = data {
                do {
                    
                    let jsonModel = try JSONDecoder().decode(PokemonDetail.self, from: data)
                    print(jsonModel)
                    DispatchQueue.main.async {
                        self.pokemonDetail = [jsonModel]
                        self.aboutPokemonViewColorBackground = BackgroundColorCreator.setBackgroundColor(pokemon: self.pokemonDetail[0])
                    }
                } catch  {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
}
