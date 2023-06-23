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
        }
    }
}


struct HomeView: View {
    @State var name = ""
    @State private var searchCommit = false
        
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
                    .padding(.top, 100)
                    
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
                            searchCommit =  true
                        }
                    }
                    NavigationLink(destination: AboutPokemon(pokemon: "1")) {
                        Text("Ver todos os Pokemons")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                            .padding(.top, 200)
                    }
                }.background(
                    Image("background")
                    // .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                )
                .navigationDestination(isPresented: $searchCommit) {
                        AboutPokemon(pokemon: name)
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
            )
    }
    
    // MARK: - Private methods
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
