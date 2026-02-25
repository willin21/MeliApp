//
//  ItemsRepository.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import Foundation
internal import os

final class SearchRepository: SearchRepositoryProtocol {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func searchItems(query: String) async throws -> SearchPage {
        let dto = try await httpClient.send(
            MercadoLibreEndpoints.productsSearch(query: query, limit: 10, offset: 0),
            as: ProductsSearchResponseDTO.self
        )

        return dto.toDomain(query: query)
    }

    func fetchItemDetail(id: String) async throws -> ItemDetail {
        let dto = try await httpClient.send(
            MercadoLibreEndpoints.productDetailById(productId: id),
            as: ProductsSearchResponseDTO.self
        )

        guard let product = dto.results.first(where: { $0.id.caseInsensitiveCompare(id) == .orderedSame })
                ?? dto.results.first else {
            throw AppError.itemNotFound
        }

        return product.toDetail()
    }
}
