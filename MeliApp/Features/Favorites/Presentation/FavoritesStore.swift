//
//  FavoritesStore.swift
//  MeliApp
//
//  Created by william niño on 12/03/26.
//

import Foundation
internal import Combine

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favoriteItems: [ItemSummary] = []
    @Published private(set) var favoriteIds: Set<String> = []

    private let repository: any FavoritesRepositoryProtocol
    private var hasLoaded = false

    init(repository: any FavoritesRepositoryProtocol) {
        self.repository = repository
        Task { [weak self] in
            await self?.loadIfNeeded()
        }
    }

    func isFavorite(_ itemId: String) -> Bool {
        favoriteIds.contains(itemId)
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        await reload()
    }

    func reload() async {
        let items = await repository.loadFavorites()
        apply(items: items)
    }

    func toggle(item: ItemSummary) {
        if favoriteIds.contains(item.id) {
            remove(itemId: item.id)
        } else {
            addOrUpdate(item: item)
        }
    }

    func toggle(itemId: String, titleFallback: String) {
        let item = ItemSummary(
            id: itemId,
            title: titleFallback,
            thumbnailURL: nil,
            price: nil,
            currencyId: nil,
            condition: nil,
            location: nil
        )
        toggle(item: item)
    }

    private func addOrUpdate(item: ItemSummary) {
        var byId: [String: ItemSummary] = Dictionary(uniqueKeysWithValues: favoriteItems.map { ($0.id, $0) })
        byId[item.id] = item

        let updated = byId.values.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        apply(items: updated)
        persist()
    }

    private func remove(itemId: String) {
        let updated = favoriteItems.filter { $0.id != itemId }
        apply(items: updated)
        persist()
    }

    private func apply(items: [ItemSummary]) {
        favoriteItems = items
        favoriteIds = Set(items.map(\.id))
    }

    private func persist() {
        let itemsToSave = favoriteItems
        let repo = repository
        Task(priority: .utility) {
            await repo.saveFavorites(itemsToSave)
        }
    }
}

