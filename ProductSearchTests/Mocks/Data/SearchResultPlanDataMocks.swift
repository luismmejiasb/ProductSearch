import Foundation
@testable import ArtistSearch

// MARK: - SearchResultITunesDataMock

enum SearchResultITunesDataMock {
    case multipleResults
    case singleResult
    case emptyResults

    // MARK: Computed Properties

    var data: Data {
        switch self {
        case .multipleResults:
            return Data(searchResultMultipleJsonString.utf8)
        case .singleResult:
            return Data(searchResultSingleJsonString.utf8)
        case .emptyResults:
            return Data(searchResultEmptyJsonString.utf8)
        }
    }

    var searchResult: ArtistSearchResult {
        do {
            var result = try JSONDecoder().decode(ArtistSearchResult.self, from: data)
            result.searchText = "iphone"
            return result
        } catch {
            fatalError("SearchResultPlanDataMocks: JSON decoding failed — \(error)")
        }
    }
}

let searchResultMultipleJsonString = """
{
    "resultCount": 3,
    "results": [
        {
            "wrapperType": "track",
            "kind": "song",
            "artistId": 909253,
            "trackId": 201281527,
            "artistName": "Jack Johnson",
            "trackName": "Upside Down",
            "collectionName": "Curious George",
            "artworkUrl60": "https://example.com/art60.jpg",
            "artworkUrl100": "https://example.com/art100.jpg",
            "trackPrice": 1.29,
            "collectionPrice": 9.99,
            "primaryGenreName": "Rock",
            "trackTimeMillis": 208643,
            "currency": "USD",
            "country": "USA",
            "previewUrl": "https://example.com/preview1.m4a"
        },
        {
            "wrapperType": "track",
            "kind": "song",
            "artistId": 136975,
            "trackId": 300001,
            "artistName": "Coldplay",
            "trackName": "The Scientist",
            "collectionName": "A Rush of Blood to the Head",
            "artworkUrl60": "https://example.com/coldplay60.jpg",
            "artworkUrl100": "https://example.com/coldplay100.jpg",
            "trackPrice": 0.99,
            "collectionPrice": 9.99,
            "primaryGenreName": "Alternative",
            "trackTimeMillis": 307893,
            "currency": "USD",
            "country": "USA",
            "previewUrl": "https://example.com/coldplay_preview.m4a"
        },
        {
            "wrapperType": "track",
            "kind": "song",
            "artistId": 478821,
            "trackId": 400001,
            "artistName": "Adele",
            "trackName": "Hello",
            "collectionName": "25",
            "artworkUrl60": "https://example.com/adele60.jpg",
            "artworkUrl100": "https://example.com/adele100.jpg",
            "trackPrice": 1.49,
            "collectionPrice": 12.99,
            "primaryGenreName": "Pop",
            "trackTimeMillis": 295400,
            "currency": "USD",
            "country": "USA",
            "previewUrl": "https://example.com/adele_preview.m4a"
        }
    ]
}
"""

let searchResultSingleJsonString = """
{
    "resultCount": 1,
    "results": [
        {
            "wrapperType": "track",
            "kind": "song",
            "artistId": 909253,
            "trackId": 201281527,
            "artistName": "Jack Johnson",
            "trackName": "Upside Down",
            "collectionName": "Curious George",
            "artworkUrl60": "https://example.com/art60.jpg",
            "artworkUrl100": "https://example.com/art100.jpg",
            "trackPrice": 1.29,
            "collectionPrice": 9.99,
            "primaryGenreName": "Rock",
            "trackTimeMillis": 208643,
            "currency": "USD",
            "country": "USA",
            "previewUrl": "https://example.com/preview1.m4a"
        }
    ]
}
"""

let searchResultEmptyJsonString = """
{
    "resultCount": 0,
    "results": []
}
"""
