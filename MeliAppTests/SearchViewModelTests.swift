//
//  SearchViewModelTests.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import XCTest
@testable import MeliApp

@MainActor
final class SearchViewModelTests: XCTestCase {

    func test_search_success_updatesLoadedState() async {
        let repo = MockSearchRepository()
        let vm = SearchViewModel(searchItemsUseCase: .init(repository: repo))

        vm.onQueryChanged("iphone")
        // evitamos debounce en test llamando directo:
        await vm.search()

        switch vm.state {
        case .loaded(let items):
            XCTAssertEqual(items.count, 1)
            XCTAssertEqual(items.first?.id, "MLA1")
        default:
            XCTFail("Expected loaded state")
        }
    }

    func test_search_emptyQuery_setsEmptyState() async {
        let repo = MockSearchRepository()
        let vm = SearchViewModel(searchItemsUseCase: .init(repository: repo))

        vm.onQueryChanged("a") // < 2 chars

        switch vm.state {
        case .empty(let message):
            XCTAssertFalse(message.isEmpty)
        default:
            XCTFail("Expected empty state")
        }
    }

    func test_search_failure_setsErrorState() async {
        let repo = MockSearchRepository()
        repo.searchResult = .failure(AppError.network(URLError(.notConnectedToInternet)))

        let vm = SearchViewModel(searchItemsUseCase: .init(repository: repo))

        vm.onQueryChanged("iphone")
        await vm.search()

        switch vm.state {
        case .error(let message):
            XCTAssertNotNil(message.errorDescription)
        default:
            XCTFail("Expected error state")
        }
    }
}
