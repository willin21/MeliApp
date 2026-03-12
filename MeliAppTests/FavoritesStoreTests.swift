//
//  FavoritesStoreTests.swift
//  MeliApp
//
//  Created by william niño on 12/03/26.
//

import XCTest
@testable import MeliApp

actor InMemoryFavoritesRepository: FavoritesRepositoryProtocol {
    private var items: [ItemSummary] = []

    func loadFavorites() async -> [ItemSummary] {
        items
    }

    func saveFavorites(_ items: [ItemSummary]) async {
        self.items = items
    }

    func currentItems() async -> [ItemSummary] {
        items
    }
}

@MainActor
final class FavoritesStoreTests: XCTestCase {

    func test_toggle_addsAndRemovesFavorite() async {
        let repo = InMemoryFavoritesRepository()
        let store = FavoritesStore(repository: repo)

        await store.reload()
        XCTAssertFalse(store.isFavorite("MLA1"))

        let item = ItemSummary(
            id: "MLA1",
            title: "iPhone 13",
            thumbnailURL: nil,
            price: 3200000,
            currencyId: "COP",
            condition: "new",
            location: "Bogotá"
        )

        store.toggle(item: item)
        XCTAssertTrue(store.isFavorite("MLA1"))
        XCTAssertEqual(store.favoriteItems.map(\.id), ["MLA1"])

        store.toggle(item: item)
        XCTAssertFalse(store.isFavorite("MLA1"))
        XCTAssertTrue(store.favoriteItems.isEmpty)
    }

    func test_repositoryPersistence_roundTrip() async {
        let suiteName = "FavoritesStoreTests.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            XCTFail("Expected UserDefaults suite")
            return
        }

        let key = "favorites.items.v1"
        defaults.removeObject(forKey: key)

        let repo = UserDefaultsFavoritesRepository(userDefaults: defaults, storageKey: key)
        let favorites: [ItemSummary] = [
            .init(
                id: "MLA1",
                title: "iPhone 13",
                thumbnailURL: "https://example.com/1.png",
                price: 3200000,
                currencyId: "COP",
                condition: "new",
                location: "Bogotá"
            ),
            .init(
                id: "MLA2",
                title: "Teclado",
                thumbnailURL: nil,
                price: nil,
                currencyId: nil,
                condition: nil,
                location: nil
            )
        ]

        await repo.saveFavorites(favorites)
        let loaded = await repo.loadFavorites()

        XCTAssertEqual(Set(loaded.map(\.id)), Set(["MLA1", "MLA2"]))
        XCTAssertEqual(loaded.first(where: { $0.id == "MLA1" })?.title, "iPhone 13")
    }
}

