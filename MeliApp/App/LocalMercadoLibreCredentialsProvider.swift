//
//  LocalMercadoLibreCredentialsProvider.swift
//  MeliApp
//
//  Created by william niño on 22/02/26.
//

import Foundation

protocol MercadoLibreCredentialsProvider {
    func accessToken() throws -> String
    func userId() throws -> String
}

final class LocalMercadoLibreCredentialsProvider: MercadoLibreCredentialsProvider {
    func accessToken() throws -> String {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "MELI_ACCESS_TOKEN") as? String,
              !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AppError.missingAccessToken
        }
        return token
    }
    
    func userId() throws -> String {
        if let number = Bundle.main.object(forInfoDictionaryKey: "MELI_USER_ID") as? NSNumber {
            return number.stringValue
        }
        
        if let text = Bundle.main.object(forInfoDictionaryKey: "MELI_USER_ID") as? String,
           !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return text
        }
        
        throw AppError.unknown
    }
}
