//
//  UserDefaultsFavoritesRepository.swift
//  MeliApp
//
//  Created by william niño on 12/03/26.
//

import Foundation

actor UserDefaultsFavoritesRepository: FavoritesRepositoryProtocol {
    private let userDefaults: UserDefaults
    private let storageKey: String

    init(
        userDefaults: UserDefaults = .standard,
        storageKey: String = "favorites.items.v1"
    ) {
        self.userDefaults = userDefaults
        self.storageKey = storageKey
    }

    func loadFavorites() async -> [ItemSummary] {
        guard let data = userDefaults.data(forKey: storageKey) else { return [] }

        do {
            return try JSONDecoder().decode([ItemSummary].self, from: data)
        } catch {
            userDefaults.removeObject(forKey: storageKey)
            return []
        }
    }

    func saveFavorites(_ items: [ItemSummary]) async {
        do {
            let data = try JSONEncoder().encode(items)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            // intentionally no-op
        }
    }
}

