import Foundation
import UIKit

@MainActor
class ArtistInfoView: UIView {
    // MARK: Properties

    var artist: ArtistResult?

    // MARK: Views

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.whiteColor
        label.text = "Genre: \(artist?.primaryGenreName ?? "Unknown")"
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = UIColor.whiteColor
        titleLabel.numberOfLines = 0
        titleLabel.text = artist?.artistName ?? artist?.trackName ?? "Unknown Artist"
        return titleLabel
    }()

    private lazy var trackNameLabel: UILabel = {
        let trackNameLabel = UILabel()
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        trackNameLabel.textColor = UIColor.whiteColor
        trackNameLabel.numberOfLines = 0
        trackNameLabel.text = "Track: \(artist?.trackName ?? "N/A")"
        return trackNameLabel
    }()

    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        priceLabel.textColor = UIColor.whiteColor
        if let price = artist?.trackPrice {
            priceLabel.text = String(format: "%.2f %@", price, artist?.currency ?? "USD")
        } else {
            priceLabel.text = "Free"
        }
        return priceLabel
    }()

    private lazy var collectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.whiteColor
        label.text = "Album: \(artist?.collectionName ?? "N/A")"
        return label
    }()

    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.whiteColor
        if let ms = artist?.trackTimeMillis {
            let seconds = ms / 1000
            label.text = String(format: "Duration: %d:%02d", seconds / 60, seconds % 60)
        } else {
            label.text = "Duration: N/A"
        }
        return label
    }()

    // MARK: Lifecycle

    // MARK: Initializers

    required init(artist: ArtistResult?) {
        self.artist = artist
        super.init(frame: CGRect.zero)

        addSubview(genreLabel)
        addSubview(titleLabel)
        addSubview(trackNameLabel)
        addSubview(priceLabel)
        addSubview(collectionLabel)
        addSubview(durationLabel)

        setupLayout()
    }

    init() {
        super.init(frame: CGRect.zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    // MARK: Layout

    private func setupLayout() {
        let borderPadding = CGFloat(20)

        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: borderPadding),
            genreLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            genreLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),

            titleLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            titleLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),

            trackNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            trackNameLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            trackNameLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),

            priceLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 15),
            priceLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            priceLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),

            collectionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 15),
            collectionLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            collectionLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),

            durationLabel.topAnchor.constraint(equalTo: collectionLabel.bottomAnchor, constant: 15),
            durationLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: borderPadding),
            durationLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -borderPadding),
        ])
    }
}

// Backward-compatible typealias
typealias InfoView = ArtistInfoView
