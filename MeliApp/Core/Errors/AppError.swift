//
//  AppError.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import Foundation

enum AppError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decoding
    case network(Error)
    case emptyQuery
    case unknown
    case httpStatusWithMessage(code: Int, message: String)
    case missingAccessToken
    case detailNotFoundInCache
    case itemNotFound
    case unauthorized
    case forbidden
    case notFound
    case server(code: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .httpStatus(let code):
            return "HTTP error (\(code))."
        case .decoding:
            return "Decoding error."
        case .network(let error):
            return error.localizedDescription
        case .emptyQuery:
            return "Query is empty."
        case .unknown:
            return "Unknown error."
        case .httpStatusWithMessage(let code, let message):
            return "HTTP (\(code)): \(message)"
        case .missingAccessToken:
            return "Missing access token."
        case .detailNotFoundInCache:
            return "Detail not found in cache."
        case .itemNotFound:
            return "Item not found."
        case .unauthorized:
            return "Unauthorized (401)."
        case .forbidden:
            return "Forbidden (403)."
        case .notFound:
            return "Not Found (404)."
        case .server(let code):
            return "Server error (\(code))."
        }
    }
    
    var userMessage: String {
        switch self {
        case .emptyQuery:
            return "Escribe al menos 2 caracteres para buscar."

        case .network:
            return "No pudimos conectarnos. Revisa tu internet e intenta de nuevo."

        case .unauthorized:
            return "Tu sesión expiró. Intenta nuevamente."

        case .forbidden:
            return "No tienes permiso para realizar esta acción."

        case .notFound, .itemNotFound:
            return "No encontramos el producto solicitado."

        case .server:
            return "El servidor no está disponible. Intenta más tarde."

        case .invalidResponse,
             .invalidURL,
             .decoding,
             .httpStatus,
             .httpStatusWithMessage,
             .detailNotFoundInCache,
             .missingAccessToken,
             .unknown:
            return "No pudimos cargar la información. Intenta de nuevo."
        }
    }
}
