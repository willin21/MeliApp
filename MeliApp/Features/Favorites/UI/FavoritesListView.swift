//
//  FavoritesListView.swift
//  MeliApp
//
//  Created by william niño on 12/03/26.
//

import SwiftUI

struct FavoritesListView: View {
    let di: AppDI
    @EnvironmentObject private var favoritesStore: FavoritesStore

    var body: some View {
        Group {
            if favoritesStore.favoriteItems.isEmpty {
                ContentUnavailableView(
                    "Sin favoritos",
                    systemImage: "heart",
                    description: Text("Marca productos con el corazón para verlos aquí.")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(favoritesStore.favoriteItems) { item in
                    NavigationLink {
                        DetailView(
                            viewModel: di.makeDetailViewModel(itemId: item.id),
                            itemTitleFallback: item.title
                        )
                    } label: {
                        ItemRowView(
                            item: item,
                            isFavorite: true,
                            onToggleFavorite: { favoritesStore.toggle(item: item) }
                        )
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color(.systemBackground))
            }
        }
        .navigationTitle("Favoritos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

