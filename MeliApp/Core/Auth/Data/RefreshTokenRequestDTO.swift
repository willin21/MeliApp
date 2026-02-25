//
//  RefreshTokenRequestDTO.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

struct RefreshTokenRequestDTO: Encodable, Sendable, Equatable {
    let grantType: String
    let clientId: String
    let clientSecret: String
    let refreshToken: String

    init(
        grantType: String = "refresh_token",
        clientId: String,
        clientSecret: String,
        refreshToken: String
    ) {
        self.grantType = grantType
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.refreshToken = refreshToken
    }

    func formURLEncodedData() -> Data {
        let pairs: [(String, String)] = [
            ("grant_type", grantType),
            ("client_id", clientId),
            ("client_secret", clientSecret),
            ("refresh_token", refreshToken)
        ]

        let body = pairs
            .map { key, value in
                "\(Self.encode(key))=\(Self.encode(value))"
            }
            .joined(separator: "&")

        return Data(body.utf8)
    }

    private static func encode(_ string: String) -> String {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "+&=")
        return string.addingPercentEncoding(withAllowedCharacters: allowed) ?? string
    }
}

