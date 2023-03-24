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
    @State private var isMyChildViewPresented = false

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
                    VStack{
                        Button(action: { self.isMyChildViewPresented = true }) {
                            ZStack {
                                
                                MyChildView(backgroundColor: Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)), pokemon: pokemon)
                            }
                        }
                        .padding(.top,20)
                        .edgesIgnoringSafeArea(.all)
                    }
                    .sheet(isPresented: $isMyChildViewPresented)  {
                        MyChildView(backgroundColor: Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)), pokemon: pokemon)
                            .padding()
                            .cornerRadius(10)
                }
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

struct MyChildView: View {
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
            .padding(.bottom, 10)
            Spacer()
         
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
            
            ZStack{
            // .overlay(
            AsyncImage(url: URL(string: pokemon.imagem.style.home.front))
            {
                image in
                image.resizable()
            } placeholder: {
                //add placeholder
            }
            .frame(width: 100, height: 100, alignment: .center)
            //   )
        }
            .padding(.top, -140)
            
            // aqui ficaria o conteúdo da MyChildView
        }
        .frame(maxWidth: 350, maxHeight: 300)
        .background(backgroundColor)
        .cornerRadius(10)
        .padding(.bottom, 20)
        Spacer()
    }
    
}
