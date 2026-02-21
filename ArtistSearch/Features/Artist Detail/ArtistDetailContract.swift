import UIKit

// MARK: - ArtistDetailFactoryProtocol

@MainActor
protocol ArtistDetailFactoryProtocol: AnyObject {
    static func initialize(artist: ArtistResult) -> ArtistDetailViewController
}

// MARK: - ArtistDetailInteractorProtocol

protocol ArtistDetailInteractorProtocol: AnyObject {}

// MARK: - ArtistDetailViewProtocol

@MainActor
protocol ArtistDetailViewProtocol: AnyObject {
    func displayArtistDetail(_ artist: ArtistResult)
}

// MARK: - ArtistDetailRouterProtocol

@MainActor
protocol ArtistDetailRouterProtocol: AnyObject {
    var view: UIViewController? { get set }

    func displayAlert(title: String, message: String)
}

// MARK: - ArtistDetailPresenterProtocol

@MainActor
protocol ArtistDetailPresenterProtocol: AnyObject {
    func displayArtistDetail()
}

