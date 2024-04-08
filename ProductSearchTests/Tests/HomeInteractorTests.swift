//
//  HomeInteractorTests.swift
//
//  Created by Luis Mejias on 22-03-22.
//

import Combine
@testable import ProductSearch
import XCTest

class HomeInteractorTests: XCTestCase {
    var interactorToTest: HomeInteractorProtocol?
    private var searchTokens = Set<AnyCancellable>()
    let searchItemSelectorName = "searchItem(offSet:searchText:)"
    let searchCategorySelectorName = "searchCategory(offSet:category:)"

    override func tearDown() {
        super.tearDown()
        interactorToTest = nil
    }

    func testSerachItemWithSuccess() {
        let status: TransactionStatus = .success
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        interactorToTest = HomeInteractor(repository: repositoryMock)
        interactorToTest?.publisher = publisher

        interactorToTest?.publisher?.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTAssertTrue(false, "Publisher should not publish error when completiting observing")
                }
            }, receiveValue: { result in
                switch result {
                case let .itemsSearchedWithSuccess(searchResult):
                    XCTAssertNotNil(searchResult)
                case .itemsSearchedWithFailure:
                    XCTAssertTrue(false, "Item searched must be successfull")
                case .categorySearchedWithSuccess:
                    XCTAssertTrue(false, "categorySearchedWithSuccess should not be called")
                case .categorySearchedWithFailure:
                    XCTAssertTrue(false, "categorySearchedWithFailure should not be called")
                }
            }
        ).store(in: &searchTokens)

        interactorToTest?.serachItem(searchText: "iPhone")

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchItemSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRepositoryFunctionsCalled) but called \(repositoryMock.functionsCalled.count)")
        }
    }

    func testSerachItemWithFailure() {
        let status: TransactionStatus = .failure
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        interactorToTest = HomeInteractor(repository: repositoryMock)
        interactorToTest?.publisher = publisher

        interactorToTest?.publisher?.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTAssertNotNil(error, "Publisher should retreive error when completiting observing")
                }
            }, receiveValue: { result in
                switch result {
                case .itemsSearchedWithSuccess:
                    XCTAssertTrue(false, "Item searched must not be successfull")
                case let .itemsSearchedWithFailure(error):
                    XCTAssertNotNil(error, "Publisher should retreive error receiving value")
                case .categorySearchedWithSuccess:
                    XCTAssertTrue(false, "categorySearchedWithSuccess should not be called")
                case .categorySearchedWithFailure:
                    XCTAssertTrue(false, "categorySearchedWithFailure should not be called")
                }
            }
        ).store(in: &searchTokens)

        interactorToTest?.serachItem(searchText: "iPhone")

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchItemSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRepositoryFunctionsCalled) but called \(repositoryMock.functionsCalled.count)")
        }
    }

    func testSearchByCategoryWithSuccess() {
        let status: TransactionStatus = .success
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        interactorToTest = HomeInteractor(repository: repositoryMock)
        interactorToTest?.publisher = publisher

        interactorToTest?.publisher?.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTAssertTrue(false, "Publisher should not publish error when completiting observing")
                }
            }, receiveValue: { result in
                switch result {
                case .itemsSearchedWithSuccess:
                    XCTAssertTrue(false, "itemsSearchedWithSuccess should not be called")
                case .itemsSearchedWithFailure:
                    XCTAssertTrue(false, "itemsSearchedWithSuccess should not be called")
                case let .categorySearchedWithSuccess(searchResult, searchedCategory):
                    XCTAssertNotNil(searchResult)
                    XCTAssertEqual(searchedCategory, .realState)
                case .categorySearchedWithFailure:
                    XCTAssertTrue(false, "Item searched must be successfull")
                }
            }
        ).store(in: &searchTokens)

        interactorToTest?.searchByCategory(.realState)

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchCategorySelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRepositoryFunctionsCalled) but called \(repositoryMock.functionsCalled.count)")
        }
    }

    func testSearchByCategoryWithFailure() {
        let status: TransactionStatus = .failure
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let publisher = PassthroughSubject<HomePublisherResult, Error>()
        interactorToTest = HomeInteractor(repository: repositoryMock)
        interactorToTest?.publisher = publisher

        interactorToTest?.publisher?.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTAssertNotNil(error, "Publisher should retreive error when completiting observing")
                }
            }, receiveValue: { result in
                switch result {
                case .itemsSearchedWithSuccess:
                    XCTAssertTrue(false, "itemsSearchedWithSuccess should not be called")
                case .itemsSearchedWithFailure:
                    XCTAssertTrue(false, "itemsSearchedWithSuccess should not be called")
                case .categorySearchedWithSuccess:
                    XCTAssertTrue(false, "Category searched result should not be successfull")
                case let .categorySearchedWithFailure(error):
                    XCTAssertNotNil(error, "Publisher should retreive error receiving value")
                }
            }
        ).store(in: &searchTokens)

        interactorToTest?.searchByCategory(.realState)

        let expectedRepositoryFunctionsCalled = 1
        if repositoryMock.functionsCalled.count == expectedRepositoryFunctionsCalled {
            XCTAssertEqual(repositoryMock.functionsCalled[0], searchCategorySelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRepositoryFunctionsCalled) but called \(repositoryMock.functionsCalled.count)")
        }
    }
}
