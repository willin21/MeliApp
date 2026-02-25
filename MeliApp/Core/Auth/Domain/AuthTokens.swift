//
//  AuthTokens.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

struct AuthTokens: Sendable, Equatable {
    let accessToken: String
    let refreshToken: String?
    let tokenType: String?
    let expiresIn: Int?
    let scope: String?
    let userId: Int?
}

