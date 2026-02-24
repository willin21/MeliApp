//
//  URLSessionHTTPClient.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import Foundation
internal import os

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let baseURL: URL

    init(
        session: URLSession = .shared,
        baseURL: URL = URL(string: "https://api.mercadolibre.com/")!
    ) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let request = try endpoint.makeURLRequest(baseURL: baseURL)
        AppLogger.network.debug("➡️ \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")

        do {
            let (data, response) = try await session.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                throw AppError.invalidResponse
            }

            switch http.statusCode {
            case 200...299:
                break
            case 401:
                throw AppError.unauthorized
            case 403:
                throw AppError.forbidden
            case 404:
                throw AppError.notFound
            case 500...599:
                throw AppError.server(code: http.statusCode)
            default:
                let backendMessage = String(data: data, encoding: .utf8) ?? "No body"
                throw AppError.httpStatusWithMessage(code: http.statusCode, message: backendMessage)
            }

            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(T.self, from: data)
                AppLogger.network.debug("✅ Decoding OK")
                return decoded
            } catch {
                AppLogger.network.error("❌ Decoding error: \(error.localizedDescription)")
                throw AppError.decoding
            }

        } catch let appError as AppError {
            throw appError
        } catch {
            AppLogger.network.error("❌ Network error: \(error.localizedDescription)")
            throw AppError.network(error)
        }
    }
}
