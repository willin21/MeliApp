//
//  FetchItemDetailUseCase.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import Foundation

struct FetchItemDetailUseCase {
    let repository: SearchRepositoryProtocol

    func execute(itemId: String) async throws -> ItemDetail {
        try await repository.fetchItemDetail(id: itemId)
    }
}
