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
    @State private var isMyChildViewPresented = false
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
                        Button(action: { self.isMyChildViewPresented = true }) {
                            ZStack {
                                
                                MyChildView(backgroundColor: Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)), pokemon: pokemon)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .edgesIgnoringSafeArea(.all)
                    }
                    .sheet(isPresented: $isMyChildViewPresented)  {
                        MyChildView(backgroundColor: Color(BackgroundColorCreator.setBackgroundColor(type: typePokemon)), pokemon: pokemon)
                            .padding()
                            .cornerRadius(10)
                    }.background(Color.red)
                        .frame(width: 350, height: 200)
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
