// MARK: - ArtistDetailInteractor

final class ArtistDetailInteractor: ArtistDetailInteractorProtocol {
    // MARK: Properties

    private let repository: ArtistDetailRepositoryProtocol

    // MARK: Lifecycle

    // MARK: - Inits

    init(repository: ArtistDetailRepositoryProtocol) {
        self.repository = repository
    }
}

