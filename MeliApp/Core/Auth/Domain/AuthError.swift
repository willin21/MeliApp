//
//  AuthError.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

enum AuthError: Error, LocalizedError, Sendable, Equatable {
    case missingAccessToken
    case missingRefreshToken

    case invalidGrant
    case expiredRefreshToken

    case badRequest(message: String?)
    case unauthorized
    case forbidden
    case server(code: Int)

    case networkFailure
    case decodingError
    case unknown

    var errorDescription: String? {
        switch self {
        case .missingAccessToken:
            return "Missing access token."
        case .missingRefreshToken:
            return "Missing refresh token."
        case .invalidGrant:
            return "Invalid grant."
        case .expiredRefreshToken:
            return "Expired refresh token."
        case .badRequest(let message):
            return message ?? "Bad request."
        case .unauthorized:
            return "Unauthorized (401)."
        case .forbidden:
            return "Forbidden (403)."
        case .server(let code):
            return "Server error (\(code))."
        case .networkFailure:
            return "Network failure."
        case .decodingError:
            return "Decoding error."
        case .unknown:
            return "Unknown auth error."
        }
    }
}

