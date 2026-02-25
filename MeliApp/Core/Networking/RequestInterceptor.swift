//
//  RequestInterceptor.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

protocol RequestInterceptor: Sendable {
    func adapt(_ request: URLRequest, for endpoint: Endpoint) async throws -> URLRequest
    func handleUnauthorized(for endpoint: Endpoint) async throws
}

