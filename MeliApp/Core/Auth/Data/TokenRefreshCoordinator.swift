//
//  TokenRefreshCoordinator.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

actor TokenRefreshCoordinator {
    private let tokenStore: TokenStoreActor
    private let refreshTokenUseCase: RefreshTokenUseCase

    private var inFlightRefresh: Task<AuthTokens, Error>?

    init(tokenStore: TokenStoreActor, refreshTokenUseCase: RefreshTokenUseCase) {
        self.tokenStore = tokenStore
        self.refreshTokenUseCase = refreshTokenUseCase
    }

    func refreshTokens() async throws -> AuthTokens {
        if let task = inFlightRefresh {
            return try await task.value
        }

        let task = Task<AuthTokens, Error> {
            let refreshToken = try await tokenStore.getRefreshToken()
            let tokens = try await refreshTokenUseCase.execute(refreshToken: refreshToken)
            try await tokenStore.setTokens(tokens)
            return tokens
        }

        inFlightRefresh = task
        defer { inFlightRefresh = nil }

        return try await task.value
    }
}

