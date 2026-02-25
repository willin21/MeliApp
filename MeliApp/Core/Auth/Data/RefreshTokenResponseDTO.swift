//
//  RefreshTokenResponseDTO.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

struct RefreshTokenResponseDTO: Decodable, Sendable, Equatable {
    let accessToken: String
    let tokenType: String?
    let expiresIn: Int?
    let scope: String?
    let userId: Int?
    let refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
        case userId = "user_id"
        case refreshToken = "refresh_token"
    }

    func toDomain() -> AuthTokens {
        AuthTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenType: tokenType,
            expiresIn: expiresIn,
            scope: scope,
            userId: userId
        )
    }
}

