//
//  AuthRepositoryProtocol.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

protocol AuthRepositoryProtocol: Sendable {
    func refreshAccessToken(refreshToken: String) async throws -> AuthTokens
}

