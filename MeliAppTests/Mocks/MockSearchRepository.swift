//
//  MockSearchRepository.swift
//  MeliApp
//
//  Created by william niño on 21/02/26.
//

import Foundation

final class MockSearchRepository: SearchRepositoryProtocol {
    var searchResult: Result<SearchPage, Error> = .success(
        SearchPage(
            query: "iphone",
            items: [
                ItemSummary(
                    id: "MLA1",
                    title: "iPhone 13",
                    thumbnailURL: nil,
                    price: 3200000,
                    currencyId: "COP",
                    condition: "new",
                    location: "Bogotá"
                )
            ]
        )
    )

    var detailResult: Result<ItemDetail, Error> = .success(
        ItemDetail(
            id: "MLA1",
            title: "iPhone 13",
            price: 3200000,
            currencyId: "COP",
            thumbnailURL: nil,
            condition: "new",
            soldQuantity: 10,
            availableQuantity: 5,
            permalink: nil,
            domainId: "MCO-CELLPHONES",
            status: "active",
            shortDescription: "Producto de prueba",
            attributes: [
                ItemDetailAttribute(id: "brand", name: "Marca", value: "Apple"),
                ItemDetailAttribute(id: "model", name: "Modelo", value: "iPhone 13")
            ],
            dateCreated: "2024-07-01T18:18:25Z",
            lastUpdated: "2025-08-30T06:15:55Z",
            qualityType: "COMPLETE",
            productStandard: true,
            searchType: "IDENTIFIER"
        )
    )

    func searchItems(query: String) async throws -> SearchPage {
        try searchResult.get()
    }

    func fetchItemDetail(id: String) async throws -> ItemDetail {
        try detailResult.get()
    }
}
