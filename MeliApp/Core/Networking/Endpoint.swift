//
//  Endpoint.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import Foundation

struct Endpoint {
    let path: String
    let method: String
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Data?
    let requiresAuthorization: Bool
    
    init(
        path: String,
        method: String = "GET",
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        requiresAuthorization: Bool = true
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.requiresAuthorization = requiresAuthorization
    }
    
    func makeURLRequest(baseURL: URL) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = components?.url else { throw AppError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}

enum MercadoLibreEndpoints {
    static let siteId = "MCO"
    
    static func productsSearch(query: String, limit: Int = 10, offset: Int = 0) -> Endpoint {
        Endpoint(
            path: "products/search",
            queryItems: [
                .init(name: "status", value: "active"),
                .init(name: "site_id", value: siteId),
                .init(name: "q", value: query),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "offset", value: "\(offset)")
            ],
            requiresAuthorization: true
        )
    }

    static func productsSearch(query: String, token: String, limit: Int = 10, offset: Int = 0) -> Endpoint {
        Endpoint(
            path: "products/search",
            queryItems: [
                .init(name: "status", value: "active"),
                .init(name: "site_id", value: siteId),
                .init(name: "q", value: query),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "offset", value: "\(offset)")
            ],
            headers: [
                "Authorization": "Bearer \(token)"
            ]
        )
    }
    
    static func productDetailById(productId: String) -> Endpoint {
        Endpoint(
            path: "products/search",
            queryItems: [
                .init(name: "status", value: "active"),
                .init(name: "site_id", value: siteId),
                .init(name: "q", value: productId),
                .init(name: "limit", value: "1"),
                .init(name: "offset", value: "0")
            ],
            requiresAuthorization: true
        )
    }

    static func productDetailById(productId: String, token: String) -> Endpoint {
        Endpoint(
            path: "products/search",
            queryItems: [
                .init(name: "status", value: "active"),
                .init(name: "site_id", value: siteId),
                .init(name: "q", value: productId),
                .init(name: "limit", value: "1"),
                .init(name: "offset", value: "0")
            ],
            headers: [
                "Authorization": "Bearer \(token)"
            ]
        )
    }
}
