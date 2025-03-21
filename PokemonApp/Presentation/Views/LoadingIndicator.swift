//
//  LoadingIndicator.swift
//  PokemonApp
//
//  Created by epena on 28/2/25.
//

import SwiftUI

struct LoadingIndicator: View {
    var isLoading: Bool

    var body: some View {
        if isLoading {
            ProgressView()
                .controlSize(.large)
                .padding(.vertical)
        } else {
            EmptyView()
        }
    }
}
