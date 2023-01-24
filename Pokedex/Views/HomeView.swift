//
//  HomeView.swift
//  Pokedex
//
//  Created by Cassiane Freitas on 25/10/22.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: Text
    @Binding var pokemonName: String
    
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            if pokemonName.isEmpty { placeholder }
            TextField("", text: $pokemonName, onEditingChanged: editingChanged, onCommit: commit)
            
            //  .padding(.trailing, 20)
        }
    }
}




struct HomeView: View {
    @ObservedObject var pokemonApiService: ViewModelPokemon
    
    @State var name = ""
    @State private var searchCommit = false
    
 //   @State var aboutPokemonViewColorBackground: UIColor = .white
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    Text("Qual Pokemon você está buscando?").font(
                        .custom(
                            "AmericanTypewriter",
                            fixedSize: 22)
                        .weight(.black)
                        
                    )
                    .foregroundColor(.yellow)
                    .padding(.top, 300)
                    
                    ZStack(alignment: .leading) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.yellow).frame(width: 30, height: 30, alignment: .leading)
                        
                        CustomTextField(placeholder: Text("Digite o nome do pokemon").foregroundColor(.white), pokemonName: $name)
                        .padding(.leading, 30) }
                    .foregroundColor(Color.white)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(border)
                    .padding(.all, 30)
                    
                    .onSubmit {
                        Task {
                            searchCommit = await fecth(searchPokemon: name.lowercased())
                            
//                            if let pokemon = pokemonApiService.pokemonDetail.first {
//                                aboutPokemonViewColorBackground = BackgroundColorCreator.setBackgroundColor(pokemon: pokemonApiService.pokemonDetail[0])
//                            }
                        }
                    }
                }.background(
                    Image("background")
                    // .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                )
                .navigationDestination(isPresented: $searchCommit) {
                 
                    if let pokemon = pokemonApiService.pokemonDetail.first {
                        
//                        AboutPokemon(pokemonApiService: pokemonApiService)
                        
                        AboutPokemon(pokemon: pokemon, circleBackground: pokemonApiService.aboutPokemonViewColorBackground)
                    }
                    
                }
                .onAppear {
                    searchCommit = false
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 16)
            .strokeBorder(
                LinearGradient(
                    gradient: .init(
                        colors: [
                            Color(.yellow)
                        ]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                // lineWidth: isEditing ? 4 : 2
            )
    }
    
    // MARK: - Private methods
    private func fecth(searchPokemon: String) async -> Bool {
        try? await pokemonApiService.fetchDetails(pokemonName: searchPokemon)
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(pokemonApiService: ViewModelPokemon())
    }
}
