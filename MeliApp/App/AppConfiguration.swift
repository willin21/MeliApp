//
//  AppConfiguration.swift
//  MeliApp
//
//  Created by Cursor on 2026-02-25.
//

import Foundation

enum Environment: String, Sendable {
    case sandbox
    case production

    var apiBaseURL: URL {
        switch self {
        case .sandbox:
            // MercadoLibre public API uses the same host; keep an explicit env toggle for enterprise config parity.
            return URL(string: "https://api.mercadolibre.com/")!
        case .production:
            return URL(string: "https://api.mercadolibre.com/")!
        }
    }
}

struct MercadoLibreOAuthClientCredentials: Sendable {
    let clientId: String
    let clientSecret: String
}

struct AppConfiguration: Sendable {
    let environment: Environment
    let oauthCredentials: MercadoLibreOAuthClientCredentials

    static func loadAtLaunch(bundle: Bundle = .main, processInfo: ProcessInfo = .processInfo) throws -> AppConfiguration {
        let env = Self.readString(key: "MELI_ENVIRONMENT", bundle: bundle, processInfo: processInfo)
            .flatMap(Environment.init(rawValue:))
            ?? .production

        guard let clientId = Self.readString(key: "MELI_CLIENT_ID", bundle: bundle, processInfo: processInfo),
              !clientId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AppError.unknown
        }

        guard let clientSecret = Self.readString(key: "MELI_CLIENT_SECRET", bundle: bundle, processInfo: processInfo),
              !clientSecret.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AppError.unknown
        }

        return AppConfiguration(
            environment: env,
            oauthCredentials: .init(clientId: clientId, clientSecret: clientSecret)
        )
    }

    private static func readString(key: String, bundle: Bundle, processInfo: ProcessInfo) -> String? {
        // Read from environment first (Scheme), fallback to Info.plist. This is called only at app launch.
        if let env = processInfo.environment[key], !env.isEmpty {
            return env
        }
        return bundle.object(forInfoDictionaryKey: key) as? String
    }
}

