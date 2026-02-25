//
//  RefreshTokenUseCase.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

protocol RefreshTokenUseCase: Sendable {
    func execute(refreshToken: String) async throws -> AuthTokens
}

struct DefaultRefreshTokenUseCase: RefreshTokenUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(refreshToken: String) async throws -> AuthTokens {
        try await repository.refreshAccessToken(refreshToken: refreshToken)
    }
}

