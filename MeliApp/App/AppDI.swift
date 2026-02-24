//
//  AppDI.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import Foundation

final class AppDI {
    private let httpClient: HTTPClient
    private let repository: SearchRepositoryProtocol

    init() {
        self.httpClient = URLSessionHTTPClient()
        let credentialsProvider = LocalMercadoLibreCredentialsProvider()

        self.repository = SearchRepository(
            httpClient: httpClient,
            credentialsProvider: credentialsProvider
        )
    }

    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(searchItemsUseCase: .init(repository: repository))
    }

    func makeDetailViewModel(itemId: String) -> DetailViewModel {
        DetailViewModel(
            itemId: itemId,
            fetchItemDetailUseCase: .init(repository: repository)
        )
    }
}
