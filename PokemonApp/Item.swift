//
//  Item.swift
//  PokemonApp
//
//  Created by epena on 26/2/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
