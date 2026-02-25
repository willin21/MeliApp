//
//  OAuthErrorResponseDTO.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

struct OAuthErrorResponseDTO: Decodable, Sendable, Equatable {
    let error: String?
    let message: String?
    let status: Int?
    let errorDescription: String?

    enum CodingKeys: String, CodingKey {
        case error
        case message
        case status
        case errorDescription = "error_description"
    }
}

