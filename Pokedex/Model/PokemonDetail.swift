//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Cassiane Freitas on 11/01/23.
//

import Foundation
import UIKit

struct PokemonDetail: Codable {
    
  //  var abilities: [String]
    var id: Int
    var name: String
    var weight: Int
    var types: [Types]
    var imagem: Sprites
    var colors: [Tipo: UIColor] = [.normal: .white]
    
    enum CodingKeys: String, CodingKey {
        case id, name, weight, types
        case imagem = "sprites"
    }
    
}

struct Sprites: Codable {
    var style: Home
    
    enum CodingKeys: String, CodingKey {
        case style = "other"
    }
}

struct Home: Codable {
    var home: Default
}

struct Default: Codable {
    var front: String
    
    enum CodingKeys: String, CodingKey {
        case front = "front_default"
    }
}

struct Types: Codable, Hashable, Equatable {
    var type: Tipos
}

struct Tipos: Codable, Hashable, Equatable {
    var name: Tipo
}

enum Tipo: String, Codable {
    case electric = "electric"
    case bug = "bug"
    case dark = "dark"
    case dragon = "dragon"
    case fairy = "fairy"
    case fighting = "fighting"
    case fire = "fire"
    case flying = "flying"
    case ghost = "ghost"
    case grass = "grass"
    case ground = "ground"
    case ice = "ice"
    case normal = "normal"
    case poison = "poison"
    case psychic = "psychic"
    case rock = "rock"
    case steel = "steel"
    case water = "water"
}
