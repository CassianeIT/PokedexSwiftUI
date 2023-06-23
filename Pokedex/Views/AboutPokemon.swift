//
//  AboutPokemon.swift
//  Pokedex
//
//  Created by Cassiane Freitas on 11/01/23.
//

import SwiftUI

struct AboutPokemon: View {
  
    @ObservedObject var pokemonApiService = ViewModelPokemon()
    @State private var pokemon: PokemonDetail?
    private var imageURLPokemon = ""
    @State private var isPokemonDescriptionPresented = false
    @State private var isViewVisible = false
    private var pokemonName = ""
    @State private var isLeftArrowVisible = false


    init(pokemon: String) {
        self.pokemonName = "pikachu"
    }
    
    var body: some View {
        ZStack {
            if let pokemon = pokemon, let typePokemon = pokemon.types[0].type.name, let imageURLPokemon = pokemon.imagem.style.home.front {
                
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
                    
                    HStack {
                        if isLeftArrowVisible {
                            
                            Image(systemName: "chevron.left")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(.leading, 40)
                                .onTapGesture {
                                    Task {
                                        if pokemon.id - 1 == 1 {
                                            isLeftArrowVisible = false
                                        }
                                        await nextPokemon(searchPokemonId: pokemon.id - 1)
                                        
                                    }
                                }
                        }
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(.trailing, 40)
                            .onTapGesture {
                                Task {
                                    await nextPokemon(searchPokemonId: pokemon.id + 1)
                                    isLeftArrowVisible = true
                                }
                            }
                    }
                    
                    
                    Text(pokemon.name.capitalized)
                        .font(.custom("OpenSans-Bold", fixedSize: 26)
                            .weight(.black)
                        )
                        .foregroundColor(.white)
                        .padding(.top, -20)
                    HStack {
                                ForEach(setupPokemonTypesAndColors().sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { (tipo, color) in
                                    Text(tipo.rawValue)
                                        .foregroundColor(Color(color))
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: .infinity)
                                                .stroke(Color(color), lineWidth: 2))
                                }
                            }
                    VStack{
                        Button(action: { self.isPokemonDescriptionPresented = true }) {
                            ZStack {
                                
                                PokemonDescription(backgroundColor: Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)), pokemon: pokemon)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: 350, height: 160)
                    }
                    .sheet(isPresented: $isPokemonDescriptionPresented)  {
                        PokemonDescription(backgroundColor: Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)), pokemon: pokemon)
                            .padding()
                            .cornerRadius(10)
                    }
                    .background(Color.red)
                    .frame(width: 350, height: 150)
                }
                .navigationBarTitle("ID: \(pokemon.id)")
            } else {
                Text("Carregando...")
            }
            
        }
        .scaleEffect(isViewVisible ? 1.0 : 0.2)
        .animation(.easeOut(duration: 1))
        .onAppear {
            fetchData(name: pokemonName)
            isViewVisible = true
            
        }
        .onDisappear{
            self.pokemon = PokemonDetail(id: 0, name: "", weight: 0, types: [Types(type: Tipos(name: .normal))], imagem: Sprites(style: Home(home: Default(front: ""))))
        }
    }
    
//    // MARK: - Private methods
    private func nextPokemon(searchPokemonId: Int) async {
        try? await pokemonApiService.fetchPokemon(pokemonName:  "\(searchPokemonId)") { result in
            pokemon = result
           }
    }

    func fetchData(name: String) {
           Task {
               do {
                   pokemonApiService.fetchPokemon(pokemonName: name.lowercased()) { result in
                       pokemon = result
                      }
                   
                  } catch {
                   print("Erro ao obter dados: \(error)")
               }
           }
       }
    
    private func setupPokemonTypesAndColors() -> [Tipo: UIColor] {
            var typesAndColors: [Tipo: UIColor] = [:]
            
            if let pokemon = pokemon {
                for type in pokemon.types {
                    typesAndColors[type.type.name] = BackgroundColorCreator.setBackgroundColor(type: type.type.name)
                }
            }
            
            return typesAndColors
        }
}

struct AboutPokemon_Previews: PreviewProvider {
    static var previews: some View {
        AboutPokemon(pokemon: "")
    }
}
