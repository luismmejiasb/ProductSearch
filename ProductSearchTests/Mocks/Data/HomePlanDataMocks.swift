import Foundation
@testable import ArtistSearch

// MARK: - HomeITunesDataMock

enum HomeITunesDataMock {
    case homeSearchArtist
    case homeSearchMusic
    case homeSearchEmpty

    // MARK: Computed Properties

    var data: Data {
        switch self {
        case .homeSearchArtist:
            return Data(homeSearchArtistJsonString.utf8)
        case .homeSearchMusic:
            return Data(homeSearchMusicJsonString.utf8)
        case .homeSearchEmpty:
            return Data(homeSearchEmptyJsonString.utf8)
        }
    }

    var searchDefaultResult: ArtistSearchResult {
        do {
            var result = try JSONDecoder().decode(ArtistSearchResult.self, from: data)
            result.searchText = "jack johnson"
            return result
        } catch {
            fatalError("HomePlanDataMocks: JSON decoding failed — \(error)")
        }
    }
}

let homeSearchArtistJsonString = """
{
    "resultCount": 2,
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
            "previewUrl": "https://example.com/preview.m4a"
        },
        {
            "wrapperType": "track",
            "kind": "song",
            "artistId": 909253,
            "trackId": 201281528,
            "artistName": "Jack Johnson",
            "trackName": "Better Together",
            "collectionName": "In Between Dreams",
            "artworkUrl60": "https://example.com/art60b.jpg",
            "artworkUrl100": "https://example.com/art100b.jpg",
            "trackPrice": 1.29,
            "collectionPrice": 9.99,
            "primaryGenreName": "Rock",
            "trackTimeMillis": 207960,
            "currency": "USD",
            "country": "USA",
            "previewUrl": "https://example.com/preview2.m4a"
        }
    ]
}
"""

let homeSearchMusicJsonString = """
{
    "resultCount": 1,
    "results": [
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
            "trackPrice": 1.29,
            "collectionPrice": 9.99,
            "primaryGenreName": "Alternative",
            "trackTimeMillis": 307893,
            "currency": "USD",
            "country": "USA",
            "previewUrl": "https://example.com/coldplay_preview.m4a"
        }
    ]
}
"""

let homeSearchEmptyJsonString = """
{
    "resultCount": 0,
    "results": []
}
"""
