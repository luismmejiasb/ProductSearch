import Foundation

// MARK: - ArtistSearchResult
// iTunes Search API response wrapper

struct ArtistSearchResult: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }

    // MARK: Properties

    let resultCount: Int?
    var results: [ArtistResult]?

    /// The original search text used to query the iTunes API.
    /// Not part of the API response — set locally after fetching.
    var searchText: String?
}

// MARK: - ArtistResult
// Single item returned by the iTunes Search API

struct ArtistResult: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case wrapperType
        case kind
        case artistId
        case collectionId
        case trackId
        case artistName
        case collectionName
        case trackName
        case collectionCensoredName
        case trackCensoredName
        case artistViewUrl
        case collectionViewUrl
        case trackViewUrl
        case previewUrl
        case artworkUrl60
        case artworkUrl100
        case collectionPrice
        case trackPrice
        case collectionExplicitness
        case trackExplicitness
        case discCount
        case discNumber
        case trackCount
        case trackNumber
        case trackTimeMillis
        case country
        case currency
        case primaryGenreName
    }

    // MARK: Properties

    let wrapperType: String?
    let kind: String?
    let artistId: Int?
    let collectionId: Int?
    let trackId: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let trackViewUrl: String?
    let previewUrl: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
}
