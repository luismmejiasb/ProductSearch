//
//  HomePresenterTests.swift
//
//  Created by Luis Mejias on 22-03-22.
//

import XCTest
import Combine
@testable import ProductSearch

class HomePresenterTests: XCTestCase {
    var viewMock = HomeViewMock()
    var routerMock = HomeRouterMock()
    var presenterToTest: HomePresenterProtocol?
    let publisher = PassthroughSubject<HomePublisherResult, Error>()
    let serachItemSelectorName = "serachItem(searchText:)"
    let searchByCategorySelectorName = "searchByCategory(_:)"
    let endLoadingIndicatorSelectorName = "endLoadingIndicator()"
    let displaySearchResultSelectorName = "displaySearchResult(_:searchType:searchCategory:)"
    let presentSearchResultSelectorName = "presentSearchResult(_:searchType:searchCategory:)"

    func testSearchItem() {
        let status: TransactionStatus = .success
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        cloudDataSourceMock.status = status
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let interactorMock = HomeInteractorMock(repository: repositoryMock)
        interactorMock.publisher = publisher
        
        presenterToTest = HomePresenter(interactor: interactorMock, router: routerMock)

        routerMock.view = viewMock
        presenterToTest = HomePresenter(interactor: interactorMock, router: routerMock)
        presenterToTest?.interactor = interactorMock
        presenterToTest?.view = viewMock
        presenterToTest?.router = routerMock

        presenterToTest?.viewDidLoad()
        presenterToTest?.searchItem(searchText: "iPhone")

        let expectedInteractorFunctionsCalled = 1
        if interactorMock.functionsCalled.count == expectedInteractorFunctionsCalled {
            XCTAssertEqual(interactorMock.functionsCalled[0], serachItemSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedInteractorFunctionsCalled) but called \(interactorMock.functionsCalled.count)")
        }
        
        let expectedViewFunctionsCalled = 2
        if viewMock.functionsCalled.count == expectedViewFunctionsCalled {
            XCTAssertEqual(viewMock.functionsCalled[0], endLoadingIndicatorSelectorName)
            XCTAssertEqual(viewMock.functionsCalled[1], displaySearchResultSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedViewFunctionsCalled) but called \(viewMock.functionsCalled.count)")
        }
    }

    func testSearchByCategory() {
        let status: TransactionStatus = .success
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        cloudDataSourceMock.status = status
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let interactorMock = HomeInteractorMock(repository: repositoryMock)
        interactorMock.publisher = publisher
        
        presenterToTest = HomePresenter(interactor: interactorMock, router: routerMock)

        routerMock.view = viewMock
        presenterToTest = HomePresenter(interactor: interactorMock, router: routerMock)
        presenterToTest?.interactor = interactorMock
        presenterToTest?.view = viewMock
        presenterToTest?.router = routerMock

        presenterToTest?.viewDidLoad()
        presenterToTest?.searchByCategory(.realState)
        
        let expectedInteractorFunctionsCalled = 1
        if interactorMock.functionsCalled.count == expectedInteractorFunctionsCalled {
            XCTAssertEqual(interactorMock.functionsCalled[0], searchByCategorySelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedInteractorFunctionsCalled) but called \(interactorMock.functionsCalled.count)")
        }
        
        let expectedViewFunctionsCalled = 2
        if viewMock.functionsCalled.count == expectedViewFunctionsCalled {
            XCTAssertEqual(viewMock.functionsCalled[0], endLoadingIndicatorSelectorName)
            XCTAssertEqual(viewMock.functionsCalled[1], displaySearchResultSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedViewFunctionsCalled) but called \(viewMock.functionsCalled.count)")
        }
    }

    func testPresentSearchSearchTextResult() {
        let status: TransactionStatus = .success
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        cloudDataSourceMock.status = status
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let interactorMock = HomeInteractorMock(repository: repositoryMock)
        interactorMock.publisher = publisher
        
        presenterToTest = HomePresenter(interactor: interactorMock, router: routerMock)

        routerMock.view = viewMock
        presenterToTest = HomePresenter(interactor: interactorMock, router: routerMock)
        presenterToTest?.interactor = interactorMock
        presenterToTest?.view = viewMock
        presenterToTest?.router = routerMock

        presenterToTest?.viewDidLoad()
        presenterToTest?.presentSearchResult(HomeMLCDataMock.homeSearchItem.searchDefaultResult!, searchType: .text, searchCategory: nil)

        let expectedRouterFunctionsCalled = 1
        if routerMock.functionsCalled.count == expectedRouterFunctionsCalled {
            XCTAssertEqual(routerMock.functionsCalled[0], presentSearchResultSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRouterFunctionsCalled) but called \(routerMock.functionsCalled.count)")
        }
    }
    
    func testPresentSearchCategoryResult() {
        let status: TransactionStatus = .success
        let cloudDataSourceMock = HomeCloudDataSourceMock(status: status)
        let localDataSourceMock = HomeLocalDataSourceMock()
        cloudDataSourceMock.status = status
        let repositoryMock = HomeRepositoryMock(status: status, localDataSource: localDataSourceMock, cloudDataSource: cloudDataSourceMock)
        let interactorMock = HomeInteractorMock(repository: repositoryMock)
        interactorMock.publisher = publisher
        
        presenterToTest = HomePresenter(interactor: interactorMock, router: routerMock)

        routerMock.view = viewMock
        presenterToTest = HomePresenter(interactor: interactorMock, router: routerMock)
        presenterToTest?.interactor = interactorMock
        presenterToTest?.view = viewMock
        presenterToTest?.router = routerMock

        presenterToTest?.viewDidLoad()
        presenterToTest?.presentSearchResult(HomeMLCDataMock.homeSearchItem.searchDefaultResult!, searchType: .category, searchCategory: .realState)

        let expectedRouterFunctionsCalled = 1
        if routerMock.functionsCalled.count == expectedRouterFunctionsCalled {
            XCTAssertEqual(routerMock.functionsCalled[0], presentSearchResultSelectorName)
        } else {
            XCTFail("Missing Functions Called. Expected \(expectedRouterFunctionsCalled) but called \(routerMock.functionsCalled.count)")
        }
    }

}
