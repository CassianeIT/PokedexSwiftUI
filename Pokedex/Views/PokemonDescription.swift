//
//  SwiftUIView.swift
//  Pokedex
//
//  Created by Cassiane da Silva de Freitas on 23/06/23.
//

import SwiftUI

struct PokemonDescription: View {
    @State private var selectedOption = 0
    private var backgroundColor: Color
    private var pokemon: PokemonDetail
    
    init(backgroundColor: Color, pokemon: PokemonDetail ) {
        self.backgroundColor = backgroundColor
        self.pokemon = pokemon
    }

    var body: some View {
        VStack {
            HStack {
                Text("Show more..")
                Image(systemName: "arrow.up.heart.fill")
            }
            .font(.headline)
            .padding(.bottom, 40)
            .padding(.top, 10)
            
            ZStack{
                VStack {
                    Picker("", selection: $selectedOption) {
                        Text("About").tag(0)
                        Text("Stats").tag(1)
                        Text("Moves").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }
                .padding(.top, 30)
                .background(Color.gray)
                .cornerRadius(10)
                
                // .overlay(
                AsyncImage(url: URL(string: pokemon.imagem.style.home.front))
                {
                    image in
                    image.resizable()
                } placeholder: {
                    //add placeholder
                }
                .frame(width: 70, height: 70, alignment: .center)
                .padding(.top, -80)
            }

            
        }
        .background(backgroundColor)
        .cornerRadius(10)
        .padding(.bottom, 20)
        Spacer()
    }
    
}

struct PokemonDescription_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDescription(backgroundColor: .gray, pokemon: PokemonDetail(id: 0, name: "", weight: 0, types: [Types(type: Tipos(name: .normal))], imagem: Sprites(style: Home(home: Default(front: "")))))
    }
}
