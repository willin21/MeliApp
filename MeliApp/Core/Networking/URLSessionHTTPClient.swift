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
    private let interceptor: RequestInterceptor?

    init(
        session: URLSession = .shared,
        baseURL: URL = URL(string: "https://api.mercadolibre.com/")!,
        interceptor: RequestInterceptor? = nil
    ) {
        self.session = session
        self.baseURL = baseURL
        self.interceptor = interceptor
    }
    
    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let request = try endpoint.makeURLRequest(baseURL: baseURL)
        let adapted = try await interceptor?.adapt(request, for: endpoint) ?? request
        AppLogger.network.debug("➡️ \(adapted.httpMethod ?? "GET") \(adapted.url?.absoluteString ?? "")")

        do {
            let (data, response) = try await session.data(for: adapted)

            guard let http = response as? HTTPURLResponse else {
                throw AppError.invalidResponse
            }

            switch http.statusCode {
            case 200...299:
                break
            case 401:
                if endpoint.requiresAuthorization, let interceptor {
                    try await interceptor.handleUnauthorized(for: endpoint)
                    return try await sendRetried(endpoint, as: type)
                }
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
        } catch let authError as AuthError {
            throw authError
        } catch {
            AppLogger.network.error("❌ Network error: \(error.localizedDescription)")
            throw AppError.network(error)
        }
    }

    private func sendRetried<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let request = try endpoint.makeURLRequest(baseURL: baseURL)
        let adapted = try await interceptor?.adapt(request, for: endpoint) ?? request

        let (data, response) = try await session.data(for: adapted)
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
    }
}
