//
//  SearchItemsUseCase.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import Foundation

struct SearchItemsUseCase {
    let repository: SearchRepositoryProtocol

    func execute(query: String) async throws -> SearchPage {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { throw AppError.emptyQuery }
        return try await repository.searchItems(query: trimmed)
    }
}
