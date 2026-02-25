//
//  AuthRepository.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

struct AuthRepository: AuthRepositoryProtocol {
    private let service: AuthServicing
    private let credentials: MercadoLibreOAuthClientCredentials

    init(service: AuthServicing, credentials: MercadoLibreOAuthClientCredentials) {
        self.service = service
        self.credentials = credentials
    }

    func refreshAccessToken(refreshToken: String) async throws -> AuthTokens {
        let dto = try await service.refreshAccessToken(credentials: credentials, refreshToken: refreshToken)
        return dto.toDomain()
    }
}

