import Foundation
@testable import ArtistSearch

// MARK: - ArtistDetailPresenterMock

class ArtistDetailPresenterMock: ArtistDetailPresenterProtocol {
    // MARK: Properties

    var functionsCalled = [String]()

    // MARK: Functions

    func displayArtistDetail() {
        functionsCalled.append(#function)
    }
}
