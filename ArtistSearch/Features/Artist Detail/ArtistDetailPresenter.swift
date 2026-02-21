import UIKit

// MARK: - ArtistDetailPresenter

@MainActor
final class ArtistDetailPresenter: ArtistDetailPresenterProtocol {
    // MARK: Properties

    private let interactor: ArtistDetailInteractorProtocol
    private let router: ArtistDetailRouterProtocol
    weak var view: ArtistDetailViewProtocol?

    private let artist: ArtistResult

    // MARK: Lifecycle

    // MARK: - Inits

    init(
        interactor: ArtistDetailInteractorProtocol,
        router: ArtistDetailRouterProtocol,
        artist: ArtistResult
    ) {
        self.interactor = interactor
        self.router = router
        self.artist = artist
    }

    // MARK: Functions

    func displayArtistDetail() {
        view?.displayArtistDetail(artist)
    }
}

