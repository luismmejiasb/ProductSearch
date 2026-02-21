import Foundation
@testable import ArtistSearch

// MARK: - ArtistDetailInteractorMock

class ArtistDetailInteractorMock: ArtistDetailInteractorProtocol {
    // MARK: Properties

    var functionsCalled = [String]()

    // MARK: Lifecycle

    init() {}
}
