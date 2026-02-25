//
//  TokenStoreActor.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

enum TokenStoreKeys {
    static let accessToken = "meli.oauth.access_token"
    static let refreshToken = "meli.oauth.refresh_token"
    static let tokenType = "meli.oauth.token_type"
    static let scope = "meli.oauth.scope"
    static let userId = "meli.oauth.user_id"
    static let expiresAt = "meli.oauth.expires_at"
}

actor TokenStoreActor {
    private let keychain: KeychainClient
    private let clock: () -> Date

    init(keychain: KeychainClient = .init(), clock: @escaping @Sendable () -> Date = Date.init) {
        self.keychain = keychain
        self.clock = clock
    }

    func getAccessToken() async throws -> String {
        guard let token = await keychain.readString(forKey: TokenStoreKeys.accessToken),
              !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthError.missingAccessToken
        }
        return token
    }

    func setAccessToken(_ token: String) async throws {
        do {
            try await keychain.upsertString(token, forKey: TokenStoreKeys.accessToken)
        } catch {
            throw AuthError.unknown
        }
    }

    func getRefreshToken() async throws -> String {
        guard let token = await keychain.readString(forKey: TokenStoreKeys.refreshToken),
              !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthError.missingRefreshToken
        }
        return token
    }

    func setRefreshToken(_ token: String) async throws {
        do {
            try await keychain.upsertString(token, forKey: TokenStoreKeys.refreshToken)
        } catch {
            throw AuthError.unknown
        }
    }

    func setTokens(_ tokens: AuthTokens) async throws {
        try await setAccessToken(tokens.accessToken)

        if let refresh = tokens.refreshToken, !refresh.isEmpty {
            try await setRefreshToken(refresh)
        }

        if let tokenType = tokens.tokenType, !tokenType.isEmpty {
            try? await keychain.upsertString(tokenType, forKey: TokenStoreKeys.tokenType)
        }
        if let scope = tokens.scope, !scope.isEmpty {
            try? await keychain.upsertString(scope, forKey: TokenStoreKeys.scope)
        }
        if let userId = tokens.userId {
            try? await keychain.upsertString(String(userId), forKey: TokenStoreKeys.userId)
        }

        if let expiresIn = tokens.expiresIn, expiresIn > 0 {
            let expiresAt = clock().addingTimeInterval(TimeInterval(expiresIn))
            try? await keychain.upsertString(String(expiresAt.timeIntervalSince1970), forKey: TokenStoreKeys.expiresAt)
        }
    }

    func clearToken() async throws {
        do {
            try await keychain.deleteValue(forKey: TokenStoreKeys.accessToken)
        } catch {
            throw AuthError.unknown
        }
    }

    func clearAll() async throws {
        do {
            try await keychain.deleteAll()
        } catch {
            throw AuthError.unknown
        }
    }
}

