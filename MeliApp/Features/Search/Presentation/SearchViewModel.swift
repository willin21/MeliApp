//
//  SearchViewModel.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import Foundation
internal import Combine
internal import os

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var state: ViewState<[ItemSummary]> = .idle
    @Published var query: String = ""

    private let searchItemsUseCase: SearchItemsUseCase
    private var searchTask: Task<Void, Never>?

    init(searchItemsUseCase: SearchItemsUseCase) {
        self.searchItemsUseCase = searchItemsUseCase
    }

    func onQueryChanged(_ newValue: String) {
        query = newValue
        searchTask?.cancel()

        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            state = .idle
            return
        }

        if trimmed.count < 2 {
            state = .empty(message: AppError.emptyQuery.userMessage)
            return
        }

        searchTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 350_000_000)
            if Task.isCancelled { return }
            await self.search()
        }
    }

    func search() async {
        state = .loading
        do {
            let page = try await searchItemsUseCase.execute(query: query)
            if page.items.isEmpty {
                state = .empty(message: "No encontramos productos para “\(query)”.")
            } else {
                state = .loaded(page.items)
            }
        } catch let error as AppError {
            AppLogger.ui.error("Search error: \(error.localizedDescription)")
            state = .error(error)
        } catch {
            AppLogger.ui.error("Search unknown error: \(error.localizedDescription)")
            state = .unknownError(message: AppError.unknown.userMessage)
        }
    }

    func retry() {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            await self?.search()
        }
    }
}
