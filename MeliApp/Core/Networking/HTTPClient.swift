//
//  HTTPClient.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import Foundation

protocol HTTPClient {
    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}
