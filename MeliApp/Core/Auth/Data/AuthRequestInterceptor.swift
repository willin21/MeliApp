//
//  AuthRequestInterceptor.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

struct AuthRequestInterceptor: RequestInterceptor {
    private let tokenStore: TokenStoreActor
    private let refreshCoordinator: TokenRefreshCoordinator

    init(tokenStore: TokenStoreActor, refreshCoordinator: TokenRefreshCoordinator) {
        self.tokenStore = tokenStore
        self.refreshCoordinator = refreshCoordinator
    }

    func adapt(_ request: URLRequest, for endpoint: Endpoint) async throws -> URLRequest {
        guard endpoint.requiresAuthorization else { return request }

        let accessToken = try await tokenStore.getAccessToken()

        var request = request
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }

    func handleUnauthorized(for endpoint: Endpoint) async throws {
        guard endpoint.requiresAuthorization else { return }
        _ = try await refreshCoordinator.refreshTokens()
    }
}

