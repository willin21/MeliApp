//
//  DetailViewModelTests.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import XCTest
@testable import MeliApp

@MainActor
final class DetailViewModelTests: XCTestCase {

    func test_load_success_updatesLoadedState() async {
        let repo = MockSearchRepository()
        let vm = DetailViewModel(
            itemId: "MLA1",
            fetchItemDetailUseCase: .init(repository: repo)
        )

        await vm.load()

        switch vm.state {
        case .loaded(let item):
            XCTAssertEqual(item.id, "MLA1")
        default:
            XCTFail("Expected loaded state")
        }
    }

    func test_load_failure_updatesErrorState() async {
        let repo = MockSearchRepository()
        repo.detailResult = .failure(AppError.httpStatus(500))

        let vm = DetailViewModel(
            itemId: "MLA1",
            fetchItemDetailUseCase: .init(repository: repo)
        )

        await vm.load()

        switch vm.state {
        case .error(let message):
            XCTAssertNotNil(message.errorDescription)
        default:
            XCTFail("Expected error state")
        }
    }
}
