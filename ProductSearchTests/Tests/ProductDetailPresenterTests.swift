import XCTest
@testable import ProductSearch

// MARK: - ProductDetailPresenterTests

@MainActor
class ProductDetailPresenterTests: XCTestCase {
    // MARK: Properties

    private var viewMock: ProductDetailViewMock!
    private var routerMock: ProductDetailRouterMock!
    private var interactorMock: ProductDetailInteractorMock!

    // MARK: Selector constants

    private let displayProductDetailSelectorName = "displayProductDetail(_:)"

    // MARK: Lifecycle

    override func setUp() {
        super.setUp()
        viewMock = ProductDetailViewMock()
        routerMock = ProductDetailRouterMock()
        interactorMock = ProductDetailInteractorMock()
    }

    override func tearDown() {
        viewMock = nil
        routerMock = nil
        interactorMock = nil
        super.tearDown()
    }

    // MARK: Helpers

    private func makeProduct(
        title: String = "iPhone 13",
        price: Int = 800000,
        condition: String = "new",
        categoryID: String = "MLC1055"
    ) -> Result {
        Result(
            id: nil,
            siteID: nil,
            title: title,
            seller: nil,
            price: price,
            prices: nil,
            currencyID: "CLP",
            availableQuantity: 1,
            soldQuantity: 0,
            buyingMode: "buy_it_now",
            listingTypeID: "gold_special",
            stopTime: nil,
            condition: condition,
            permalink: nil,
            thumbnail: nil,
            thumbnailID: nil,
            acceptsMercadopago: true,
            installments: nil,
            address: nil,
            shipping: nil,
            sellerAddress: nil,
            attributes: nil,
            differentialPricing: nil,
            originalPrice: nil,
            categoryID: categoryID,
            officialStoreID: nil,
            domainID: nil,
            catalogProductID: nil,
            tags: nil,
            catalogListing: nil,
            useThumbnailID: nil,
            orderBackend: nil
        )
    }

    private func makeSUT(product: Result) -> ProductDetailPresenter {
        let presenter = ProductDetailPresenter(
            interactor: interactorMock,
            router: routerMock,
            product: product
        )
        presenter.view = viewMock
        return presenter
    }

    // MARK: - Tests: displayProductDetail

    func testDisplayProductDetailCallsViewMethod() {
        // given
        let product = makeProduct()
        let presenter = makeSUT(product: product)

        // when
        presenter.displayProductDetail()

        // then
        XCTAssertEqual(viewMock.functionsCalled.count, 1)
        XCTAssertEqual(viewMock.functionsCalled[0], displayProductDetailSelectorName)
    }

    func testDisplayProductDetailPassesCorrectTitle() {
        // given
        let product = makeProduct(title: "MacBook Pro 16")
        let presenter = makeSUT(product: product)

        // when
        presenter.displayProductDetail()

        // then
        XCTAssertEqual(viewMock.receivedProduct?.title, "MacBook Pro 16")
    }

    func testDisplayProductDetailPassesCorrectPrice() {
        // given
        let product = makeProduct(price: 1_200_000)
        let presenter = makeSUT(product: product)

        // when
        presenter.displayProductDetail()

        // then
        XCTAssertEqual(viewMock.receivedProduct?.price, 1_200_000)
    }

    func testDisplayProductDetailPassesCorrectCondition() {
        // given
        let product = makeProduct(condition: "used")
        let presenter = makeSUT(product: product)

        // when
        presenter.displayProductDetail()

        // then
        XCTAssertEqual(viewMock.receivedProduct?.condition, "used")
    }

    func testDisplayProductDetailPassesCorrectCategoryID() {
        // given
        let product = makeProduct(categoryID: "MLC1743")
        let presenter = makeSUT(product: product)

        // when
        presenter.displayProductDetail()

        // then
        XCTAssertEqual(viewMock.receivedProduct?.categoryID, "MLC1743")
    }

    func testDisplayProductDetailCalledMultipleTimesCallsViewEachTime() {
        // given
        let product = makeProduct()
        let presenter = makeSUT(product: product)

        // when
        presenter.displayProductDetail()
        presenter.displayProductDetail()
        presenter.displayProductDetail()

        // then
        XCTAssertEqual(viewMock.functionsCalled.count, 3)
        XCTAssertTrue(viewMock.functionsCalled.allSatisfy { $0 == self.displayProductDetailSelectorName })
    }

    func testDisplayProductDetailWithNilViewDoesNotCrash() {
        // given
        let product = makeProduct()
        let presenter = ProductDetailPresenter(
            interactor: interactorMock,
            router: routerMock,
            product: product
        )
        presenter.view = nil

        // when
        presenter.displayProductDetail()

        // then (should not crash, view is simply not called)
        XCTAssertTrue(viewMock.functionsCalled.isEmpty)
    }

    func testDisplayProductDetailDoesNotCallRouter() {
        // given
        let product = makeProduct()
        let presenter = makeSUT(product: product)

        // when
        presenter.displayProductDetail()

        // then
        XCTAssertTrue(routerMock.functionsCalled.isEmpty)
    }

    func testDisplayProductDetailDoesNotCallInteractor() {
        // given
        let product = makeProduct()
        let presenter = makeSUT(product: product)

        // when
        presenter.displayProductDetail()

        // then
        XCTAssertTrue(interactorMock.functionsCalled.isEmpty)
    }

    // MARK: - Tests: View receives same product that was injected

    func testDisplayProductDetailViewReceivesSameProductPassedOnInit() {
        // given
        let product = makeProduct(title: "Samsung Galaxy S23", price: 550000)
        let presenter = makeSUT(product: product)

        // when
        presenter.displayProductDetail()

        // then
        XCTAssertEqual(viewMock.receivedProduct?.title, product.title)
        XCTAssertEqual(viewMock.receivedProduct?.price, product.price)
    }
}
