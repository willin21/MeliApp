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
    private let credentialsProvider: MercadoLibreCredentialsProvider

    init(httpClient: HTTPClient, credentialsProvider: MercadoLibreCredentialsProvider) {
        self.httpClient = httpClient
        self.credentialsProvider = credentialsProvider
    }

    func searchItems(query: String) async throws -> SearchPage {
        let token = try credentialsProvider.accessToken()

        let dto = try await httpClient.send(
            MercadoLibreEndpoints.productsSearch(query: query, token: token, limit: 10, offset: 0),
            as: ProductsSearchResponseDTO.self
        )

        return dto.toDomain(query: query)
    }

    func fetchItemDetail(id: String) async throws -> ItemDetail {
        let token = try credentialsProvider.accessToken()

        let dto = try await httpClient.send(
            MercadoLibreEndpoints.productDetailById(productId: id, token: token),
            as: ProductsSearchResponseDTO.self
        )

        guard let product = dto.results.first(where: { $0.id.caseInsensitiveCompare(id) == .orderedSame })
                ?? dto.results.first else {
            throw AppError.itemNotFound
        }

        return product.toDetail()
    }
}
