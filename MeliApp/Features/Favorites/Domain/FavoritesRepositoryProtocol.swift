//
//  FavoritesRepositoryProtocol.swift
//  MeliApp
//
//  Created by william niño on 12/03/26.
//

import Foundation

protocol FavoritesRepositoryProtocol: Sendable {
    func loadFavorites() async -> [ItemSummary]
    func saveFavorites(_ items: [ItemSummary]) async
}

