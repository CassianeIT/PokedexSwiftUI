//
//  AboutPokemon.swift
//  Pokedex
//
//  Created by Cassiane Freitas on 11/01/23.
//

import SwiftUI

struct AboutPokemon: View {
    private var pokemonTypesAndColors: [Tipo: UIColor] = [:]
    private var pokemon: PokemonDetail
    private var typePokemon: Tipo
    private var imageURLPokemon: String
    
    init(pokemon: PokemonDetail) {
        self.pokemon = pokemon
        self.typePokemon = pokemon.types[0].type.name
        self.imageURLPokemon = pokemon.imagem.style.home.front
        
        for i in self.pokemon.types {
            self.pokemonTypesAndColors[i.type.name] = BackgroundColorCreator.setBackgroundColor(type: i.type.name)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)).opacity(0.6), .gray.opacity(0.2), .black]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(gradient: Gradient(colors: [Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)).opacity(0.1), Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)).opacity(0.3), Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)).opacity(0.4),  Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)).opacity(0.7)]), center: .center, startRadius: 50, endRadius: 150)
                        )
                        .frame(width: 350, height: 350)
                  
                    AsyncImage(url: URL(string: imageURLPokemon))
                    {
                        image in
                        image.resizable()
                    } placeholder: {
                        //add placeholder
                    }
                    .frame(width: 450, height: 450, alignment: .center)
                        
                }
                Text(pokemon.name.capitalized)
                    .font(.custom("OpenSans-Bold", fixedSize: 26)
                        .weight(.black)
                )
                .foregroundColor(.white)
                .padding(.top, 20)
                
                HStack {
                        
                    ForEach(pokemonTypesAndColors.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { (tipo, color) in

                        Text(tipo.rawValue)
                            .foregroundColor(Color(color))
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color(color), lineWidth: 2))
                               }
                }
                Spacer()
                
            }
            .navigationBarTitle("ID: \(pokemon.id)")
            
        }

    }
}

struct AboutPokemon_Previews: PreviewProvider {
    static var previews: some View {
        AboutPokemon(pokemon: PokemonDetail(id: 0, name: "", weight: 0, types: [Types(type: Tipos(name: .normal))], imagem: Sprites(style: Home(home: Default(front: "")))))
    }
}
