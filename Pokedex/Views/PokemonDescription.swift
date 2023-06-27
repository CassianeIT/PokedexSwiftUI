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
                Text(pokemon.name.capitalized)
                
            }
            .font(.headline)
            .padding(.bottom, 40)
            .padding(.top, -20)
            
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
                .background(backgroundColor)
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
            
            ZStack {
                switch selectedOption {
                case 0:
                    Group {
                        VStack {
                            HStack {
                                Image(systemName: "scalemass")
                                Text("\(pokemon.weight) kg\nWeight")
                                
                                Divider().frame(height: 40).background(Color.gray)
                                
                                Image(systemName: "ruler").rotationEffect(.degrees(-90))
                                Text(String(format: "%.1f m\nHeight", pokemon.height))
                                
                            }
                            
                            .padding(.all, 20)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            
                            ForEach(pokemon.stats, id: \.stat.name) { stat in
                                HStack {
                                    Text(String(format: "\(stat.stat.name.capitalized): %.1f", stat.baseStat))
                                    Spacer()
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .foregroundColor(Color.gray.opacity(0.2))
                                            .frame(height: 10)
                                        
                                        Rectangle()
                                            .foregroundColor(backgroundColor)
                                            .frame(width: CGFloat((stat.baseStat / 450) * 100), height: 10)
                                    } .frame(width: 100)
                                }
                                .padding(.horizontal)
                            }
                            
                            
                        }
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    
                case 1:
                    Group {
                        Text("Stats View")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .fixedSize(horizontal: false, vertical: true)
                    
                case 2:
                    Group {
                        Text("Moves View")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    
                default:
                    EmptyView()
                }
            }
            //            .background(Color.blue)
            //            .frame(maxWidth: 350, maxHeight: 400)
            .padding(.bottom, 10)
            .cornerRadius(10)
            .shadow(color: backgroundColor.opacity(0.6), radius: 10, x: 0, y: 5)
            
        }
        //        .background(Color.red)
        .padding(.all, 20)
        .cornerRadius(10)
        .padding(.bottom, 20)
    }
    
}

struct PokemonDescription_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDescription(backgroundColor: .gray, pokemon: PokemonDetail(id: 0, name: "", weight: 0, types: [Types(type: Tipos(name: .normal))], imagem: Sprites(style: Home(home: Default(front: ""))), height: 0.0, stats: [PokemonStat(baseStat: 0, stat: Stat(name: ""))]))
    }
}
