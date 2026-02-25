//
//  AuthService.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

protocol AuthServicing: Sendable {
    func refreshAccessToken(
        credentials: MercadoLibreOAuthClientCredentials,
        refreshToken: String
    ) async throws -> RefreshTokenResponseDTO
}

struct AuthService: AuthServicing {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func refreshAccessToken(
        credentials: MercadoLibreOAuthClientCredentials,
        refreshToken: String
    ) async throws -> RefreshTokenResponseDTO {
        let requestDTO = RefreshTokenRequestDTO(
            clientId: credentials.clientId,
            clientSecret: credentials.clientSecret,
            refreshToken: refreshToken
        )

        let endpoint = Endpoint(
            path: "oauth/token",
            method: "POST",
            headers: [
                "Content-Type": "application/x-www-form-urlencoded"
            ],
            body: requestDTO.formURLEncodedData(),
            requiresAuthorization: false
        )

        do {
            return try await httpClient.send(endpoint, as: RefreshTokenResponseDTO.self)
        } catch let error as AppError {
            throw Self.map(error)
        } catch {
            throw AuthError.unknown
        }
    }

    private static func map(_ error: AppError) -> AuthError {
        switch error {
        case .unauthorized:
            return .unauthorized
        case .forbidden:
            return .forbidden
        case .server(let code):
            return .server(code: code)
        case .decoding:
            return .decodingError
        case .network:
            return .networkFailure
        case .httpStatusWithMessage(let code, let message):
            if code == 400, let oauthError = decodeOAuthError(from: message) {
                let normalized = (oauthError.error ?? oauthError.message ?? "").lowercased()
                if normalized == "invalid_grant" {
                    let desc = (oauthError.errorDescription ?? oauthError.message ?? "").lowercased()
                    if desc.contains("expired") {
                        return .expiredRefreshToken
                    }
                    return .invalidGrant
                }
                return .badRequest(message: oauthError.errorDescription ?? oauthError.message)
            }
            return .badRequest(message: message)
        case .httpStatus(let code):
            if code == 401 { return .unauthorized }
            if code == 403 { return .forbidden }
            if (500...599).contains(code) { return .server(code: code) }
            return .badRequest(message: "HTTP (\(code))")
        case .invalidResponse, .invalidURL, .emptyQuery, .unknown, .missingAccessToken,
             .detailNotFoundInCache, .itemNotFound, .notFound:
            return .unknown
        }
    }

    private static func decodeOAuthError(from rawBody: String) -> OAuthErrorResponseDTO? {
        let data = Data(rawBody.utf8)
        return try? JSONDecoder().decode(OAuthErrorResponseDTO.self, from: data)
    }
}

