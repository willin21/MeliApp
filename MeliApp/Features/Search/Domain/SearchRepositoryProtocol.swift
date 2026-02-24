//
//  SearchRepositoryProtocol.swift
//  MeliApp
//
//  Created by william niño on 21/02/26.
//

import Foundation

protocol SearchRepositoryProtocol {
    func searchItems(query: String) async throws -> SearchPage
    func fetchItemDetail(id: String) async throws -> ItemDetail
}
