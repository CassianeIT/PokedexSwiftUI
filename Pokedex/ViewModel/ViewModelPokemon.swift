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
    @Published var pokemonColorsTypes: [Tipo: UIColor] = [:]

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
                  //  print(jsonModel)
                    DispatchQueue.main.async { [self] in
                        self.pokemonDetail = [jsonModel]
                        self.aboutPokemonViewColorBackground = BackgroundColorCreator.setBackgroundColor(type: self.pokemonDetail[0].types[0].type.name)
                        
                        for i in self.pokemonDetail[0].types {
                            self.pokemonColorsTypes[i.type.name] = BackgroundColorCreator.setBackgroundColor(type: i.type.name)
                        }
                        pokemonDetail[0].colors = pokemonColorsTypes

                    }
                } catch  {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
}
