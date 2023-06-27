//
//  BackgroundColorCreator.swift
//  Pokedex
//
//  Created by Cassiane Freitas on 11/01/23.
//

import Foundation
import UIKit
import SwiftUI

enum BackgroundColorCreator {
    
    static func setBackgroundColor(type: Tipo) -> UIColor {
        let typePokemon: Tipo = type
        
        var circleBackground: UIColor = .white

        switch typePokemon {
        case .electric:
            circleBackground = .yellow
        case .bug:
            circleBackground = .green
        case .dark:
            circleBackground = .black
        case .dragon:
            circleBackground = .blue
        case .fairy:
            circleBackground = .magenta
        case .fighting:
            circleBackground = .red
        case .fire:
            circleBackground = .yellow
        case .flying:
            circleBackground = .cyan
        case .ghost:
            circleBackground = .purple
        case .grass:
            circleBackground = .green
        case .ground:
            circleBackground = .brown
        case .ice:
            circleBackground = .blue
        case .normal:
            circleBackground = .lightGray
        case .poison:
            circleBackground = .purple
        case .psychic:
            circleBackground = .red
        case .rock:
            circleBackground = .brown
        case .steel:
            circleBackground = .darkGray
        case .water:
            circleBackground = .blue
        }
        return circleBackground
    }
}
