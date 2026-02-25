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
        let configuration = (try? AppConfiguration.loadAtLaunch()) ?? AppConfiguration(
            environment: .production,
            oauthCredentials: .init(clientId: "", clientSecret: "")
        )

        let baseURL = configuration.environment.apiBaseURL

        let keychain = KeychainClient()
        Self.seedTokenIfNeeded(keychain: keychain)

        let tokenStore = TokenStoreActor(keychain: keychain)

        let authHTTPClient = URLSessionHTTPClient(baseURL: baseURL)
        let authService = AuthService(httpClient: authHTTPClient)
        let authRepository = AuthRepository(service: authService, credentials: configuration.oauthCredentials)
        let refreshUseCase = DefaultRefreshTokenUseCase(repository: authRepository)
        let refreshCoordinator = TokenRefreshCoordinator(tokenStore: tokenStore, refreshTokenUseCase: refreshUseCase)

        let interceptor = AuthRequestInterceptor(tokenStore: tokenStore, refreshCoordinator: refreshCoordinator)
        self.httpClient = URLSessionHTTPClient(baseURL: baseURL, interceptor: interceptor)

        self.repository = SearchRepository(
            httpClient: httpClient
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

    private static func seedTokenIfNeeded(keychain: KeychainClient, bundle: Bundle = .main, processInfo: ProcessInfo = .processInfo) {
        func read(_ key: String) -> String? {
            if let env = processInfo.environment[key], !env.isEmpty { return env }
            return bundle.object(forInfoDictionaryKey: key) as? String
        }

        if let seedAccessToken = read("MELI_ACCESS_TOKEN"),
           !seedAccessToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           keychain.readString(forKey: TokenStoreKeys.accessToken) == nil {
            try? keychain.upsertString(seedAccessToken, forKey: TokenStoreKeys.accessToken)
        }

        if let seedRefreshToken = read("MELI_REFRESH_TOKEN"),
           !seedRefreshToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           keychain.readString(forKey: TokenStoreKeys.refreshToken) == nil {
            try? keychain.upsertString(seedRefreshToken, forKey: TokenStoreKeys.refreshToken)
        }
    }
}
