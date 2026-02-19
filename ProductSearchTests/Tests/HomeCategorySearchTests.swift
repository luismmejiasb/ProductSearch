import XCTest
@testable import ProductSearch

// MARK: - HomeCategorySearchTests

class HomeCategorySearchTests: XCTestCase {
    // MARK: - Tests: stringValue

    func testStringValue_vehicule_returnsMLC1743() {
        XCTAssertEqual(HomeCategorySearch.vehicule.stringValue, "MLC1743")
    }

    func testStringValue_realState_returnsMLC1459() {
        XCTAssertEqual(HomeCategorySearch.realState.stringValue, "MLC1459")
    }

    func testStringValue_services_returnsMLC1540() {
        XCTAssertEqual(HomeCategorySearch.services.stringValue, "MLC1540")
    }

    func testStringValue_none_returnsEmptyString() {
        XCTAssertEqual(HomeCategorySearch.none.stringValue, "")
    }

    // MARK: - Tests: uiTitle

    func testUITitle_vehicule_returnsVehiculos() {
        XCTAssertEqual(HomeCategorySearch.vehicule.uiTitle, "Vehículos")
    }

    func testUITitle_realState_returnsInmuebles() {
        XCTAssertEqual(HomeCategorySearch.realState.uiTitle, "Inmuebles")
    }

    func testUITitle_services_returnsServicios() {
        XCTAssertEqual(HomeCategorySearch.services.uiTitle, "Servicios")
    }

    func testUITitle_none_returnsEmptyString() {
        XCTAssertEqual(HomeCategorySearch.none.uiTitle, "")
    }

    // MARK: - Tests: rawValue

    func testRawValue_vehicule_is0() {
        XCTAssertEqual(HomeCategorySearch.vehicule.rawValue, 0)
    }

    func testRawValue_realState_is1() {
        XCTAssertEqual(HomeCategorySearch.realState.rawValue, 1)
    }

    func testRawValue_services_is2() {
        XCTAssertEqual(HomeCategorySearch.services.rawValue, 2)
    }

    func testRawValue_none_is3() {
        XCTAssertEqual(HomeCategorySearch.none.rawValue, 3)
    }

    // MARK: - Tests: Equality

    func testEquality_sameCategory_isEqual() {
        XCTAssertEqual(HomeCategorySearch.vehicule, HomeCategorySearch.vehicule)
        XCTAssertEqual(HomeCategorySearch.none, HomeCategorySearch.none)
    }

    func testEquality_differentCategories_isNotEqual() {
        XCTAssertNotEqual(HomeCategorySearch.vehicule, HomeCategorySearch.realState)
        XCTAssertNotEqual(HomeCategorySearch.services, HomeCategorySearch.none)
    }

    // MARK: - Tests: allCases stringValues are unique

    func testAllStringValues_areUnique() {
        let values = [
            HomeCategorySearch.vehicule.stringValue,
            HomeCategorySearch.realState.stringValue,
            HomeCategorySearch.services.stringValue,
            HomeCategorySearch.none.stringValue
        ]
        let unique = Set(values.filter { !$0.isEmpty })
        XCTAssertEqual(unique.count, 3, "All non-empty stringValues should be unique")
    }
}
