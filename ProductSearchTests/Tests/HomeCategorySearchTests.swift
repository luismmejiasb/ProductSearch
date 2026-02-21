import XCTest
@testable import ArtistSearch

// MARK: - HomeCategorySearchTests

class HomeCategorySearchTests: XCTestCase {
    // MARK: - Tests: mediaType

    func testAllMusicGenresReturnMusicMediaType() {
        let musicGenres: [HomeCategorySearch] = [
            .reggaeton, .salsa, .merengue, .bachata, .cumbia,
            .pop, .rock, .jazz, .electronica, .hipHop
        ]
        for genre in musicGenres {
            XCTAssertEqual(genre.mediaType, "music", "Genre \(genre) should have mediaType 'music'")
        }
    }

    func testMediaTypeNoneReturnsEmptyString() {
        XCTAssertEqual(HomeCategorySearch.none.mediaType, "")
    }

    // MARK: - Tests: uiTitle

    func testUITitleReggaetonReturnsReggaeton() {
        XCTAssertEqual(HomeCategorySearch.reggaeton.uiTitle, "Reggaeton")
    }

    func testUITitleSalsaReturnsSalsa() {
        XCTAssertEqual(HomeCategorySearch.salsa.uiTitle, "Salsa")
    }

    func testUITitleMerengueReturnsMerengue() {
        XCTAssertEqual(HomeCategorySearch.merengue.uiTitle, "Merengue")
    }

    func testUITitleBachataReturnsBachata() {
        XCTAssertEqual(HomeCategorySearch.bachata.uiTitle, "Bachata")
    }

    func testUITitleCumbiaReturnsCumbia() {
        XCTAssertEqual(HomeCategorySearch.cumbia.uiTitle, "Cumbia")
    }

    func testUITitlePopReturnsPop() {
        XCTAssertEqual(HomeCategorySearch.pop.uiTitle, "Pop")
    }

    func testUITitleRockReturnsRock() {
        XCTAssertEqual(HomeCategorySearch.rock.uiTitle, "Rock")
    }

    func testUITitleJazzReturnsJazz() {
        XCTAssertEqual(HomeCategorySearch.jazz.uiTitle, "Jazz")
    }

    func testUITitleElectronicaReturnsElectronica() {
        XCTAssertEqual(HomeCategorySearch.electronica.uiTitle, "Electrónica")
    }

    func testUITitleHipHopReturnsHipHop() {
        XCTAssertEqual(HomeCategorySearch.hipHop.uiTitle, "Hip-Hop")
    }

    func testUITitleNoneReturnsEmptyString() {
        XCTAssertEqual(HomeCategorySearch.none.uiTitle, "")
    }

    // MARK: - Tests: rawValue

    func testRawValuesAreSequential() {
        XCTAssertEqual(HomeCategorySearch.reggaeton.rawValue,  0)
        XCTAssertEqual(HomeCategorySearch.salsa.rawValue,      1)
        XCTAssertEqual(HomeCategorySearch.merengue.rawValue,   2)
        XCTAssertEqual(HomeCategorySearch.bachata.rawValue,    3)
        XCTAssertEqual(HomeCategorySearch.cumbia.rawValue,     4)
        XCTAssertEqual(HomeCategorySearch.pop.rawValue,        5)
        XCTAssertEqual(HomeCategorySearch.rock.rawValue,       6)
        XCTAssertEqual(HomeCategorySearch.jazz.rawValue,       7)
        XCTAssertEqual(HomeCategorySearch.electronica.rawValue, 8)
        XCTAssertEqual(HomeCategorySearch.hipHop.rawValue,    9)
        XCTAssertEqual(HomeCategorySearch.none.rawValue,      10)
    }

    // MARK: - Tests: Equality

    func testEqualitySameCategoryIsEqual() {
        XCTAssertEqual(HomeCategorySearch.reggaeton, HomeCategorySearch.reggaeton)
        XCTAssertEqual(HomeCategorySearch.none, HomeCategorySearch.none)
    }

    func testEqualityDifferentCategoriesIsNotEqual() {
        XCTAssertNotEqual(HomeCategorySearch.reggaeton, HomeCategorySearch.salsa)
        XCTAssertNotEqual(HomeCategorySearch.pop, HomeCategorySearch.none)
    }

    // MARK: - Tests: all genre mediaTypes are the same ("music")

    func testAllNonNoneMediaTypesEqualMusic() {
        let allGenres: [HomeCategorySearch] = [
            .reggaeton, .salsa, .merengue, .bachata, .cumbia,
            .pop, .rock, .jazz, .electronica, .hipHop
        ]
        for genre in allGenres {
            XCTAssertEqual(genre.mediaType, "music")
        }
    }
}
