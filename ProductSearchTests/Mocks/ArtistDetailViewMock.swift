import Foundation
@testable import ArtistSearch

// MARK: - ArtistDetailViewMock

class ArtistDetailViewMock: ArtistDetailViewProtocol {
    // MARK: Properties

    var functionsCalled = [String]()
    var receivedArtist: ArtistResult?

    // MARK: Functions

    func displayArtistDetail(_ artist: ArtistResult) {
        functionsCalled.append(#function)
        receivedArtist = artist
    }
}
