import XCTest
@testable import ProductSearch

// MARK: - HomeCategorySearchTests

class HomeCategorySearchTests: XCTestCase {
    // MARK: - Tests: stringValue

    func testStringValueVehiculeReturnsMLC1743() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.vehicule.stringValue, "MLC1743")
    }

    func testStringValueRealStateReturnsMLC1459() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.realState.stringValue, "MLC1459")
    }

    func testStringValueServicesReturnsMLC1540() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.services.stringValue, "MLC1540")
    }

    func testStringValueNoneReturnsEmptyString() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.none.stringValue, "")
    }

    // MARK: - Tests: uiTitle

    func testUITitleVehiculeReturnsVehiculos() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.vehicule.uiTitle, "Vehículos")
    }

    func testUITitleRealStateReturnsInmuebles() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.realState.uiTitle, "Inmuebles")
    }

    func testUITitleServicesReturnsServicios() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.services.uiTitle, "Servicios")
    }

    func testUITitleNoneReturnsEmptyString() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.none.uiTitle, "")
    }

    // MARK: - Tests: rawValue

    func testRawValueVehiculeIsZero() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.vehicule.rawValue, 0)
    }

    func testRawValueRealStateIsOne() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.realState.rawValue, 1)
    }

    func testRawValueServicesIsTwo() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.services.rawValue, 2)
    }

    func testRawValueNoneIsThree() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.none.rawValue, 3)
    }

    // MARK: - Tests: Equality

    func testEqualitySameCategoryIsEqual() {
        // when / then
        XCTAssertEqual(HomeCategorySearch.vehicule, HomeCategorySearch.vehicule)
        XCTAssertEqual(HomeCategorySearch.none, HomeCategorySearch.none)
    }

    func testEqualityDifferentCategoriesIsNotEqual() {
        // when / then
        XCTAssertNotEqual(HomeCategorySearch.vehicule, HomeCategorySearch.realState)
        XCTAssertNotEqual(HomeCategorySearch.services, HomeCategorySearch.none)
    }

    // MARK: - Tests: allCases stringValues are unique

    func testAllStringValuesAreUnique() {
        // given
        let values = [
            HomeCategorySearch.vehicule.stringValue,
            HomeCategorySearch.realState.stringValue,
            HomeCategorySearch.services.stringValue,
            HomeCategorySearch.none.stringValue
        ]

        // when
        let unique = Set(values.filter { !$0.isEmpty })

        // then
        XCTAssertEqual(unique.count, 3, "All non-empty stringValues should be unique")
    }
}
