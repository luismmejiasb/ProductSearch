import UIKit

// MARK: - SearchResultUITableViewCell

@MainActor
final class SearchResultUITableViewCell: UITableViewCell {
    // MARK: Static Properties

    static let reusableIdentifier = "searchResultTableViewCell"

    // MARK: Properties

    // MARK: Outlets

    @IBOutlet private var artistNameLabel: UILabel! {
        didSet {
            artistNameLabel.textColor = UIColor.whiteColor
        }
    }
    @IBOutlet private var artistPriceLabel: UILabel! {
        didSet {
            artistPriceLabel.textColor = UIColor.whiteColor
        }
    }
    @IBOutlet private var artistLocationLabel: UILabel! {
        didSet {
            artistLocationLabel.textColor = UIColor.whiteColor
        }
    }
    @IBOutlet private var artistImageView: UIImageView!

    private var imageLoadingTask: Task<Void, Never>?

    // MARK: Overridden Functions

    override func prepareForReuse() {
        super.prepareForReuse()

        imageLoadingTask?.cancel()
        imageLoadingTask = nil

        artistImageView.image = nil
    }

    // MARK: Functions

    // MARK: Configuration

    func configureCell(with artistData: ArtistResult) {
        selectionStyle = .none
        backgroundColor = UIColor.clearColor
        artistNameLabel.text = artistData.artistName ?? artistData.trackName ?? "Unknown Artist"

        if let price = artistData.trackPrice {
            artistPriceLabel.text = String(format: "$%.2f %@", price, artistData.currency ?? "USD")
        } else {
            artistPriceLabel.text = "Price not available"
        }

        artistLocationLabel.text = artistData.primaryGenreName ?? artistData.kind ?? "Unknown Genre"

        loadImage(from: artistData.artworkUrl100 ?? artistData.artworkUrl60)
    }
}

private extension SearchResultUITableViewCell {
    func loadImage(from urlString: String?) {
        imageLoadingTask = Task { @MainActor in
            await artistImageView.setImage(
                from: urlString ?? "",
                placeholder: UIImage(named: "productPlaceholderIcon")
            )
        }
    }
}
