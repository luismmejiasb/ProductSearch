import Foundation

// MARK: - APIURL

enum APIURL {
    case searchArtist(searchText: String, limit: Int)
    case searchByMedia(mediaType: String, searchText: String, limit: Int)

    // MARK: Computed Properties

    var url: URL {
        guard let unwrappedUrl = URL(string: "https://itunes.apple.com" + path) else {
            return URL(string: "https://itunes.apple.com")!
        }
        return unwrappedUrl
    }
}

private extension APIURL {
    var path: String {
        switch self {
        case .searchArtist(let searchText, let limit):
            let encoded = searchText.replacingOccurrences(of: " ", with: "+")
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText
            return "/search?term=\(encoded)&limit=\(limit)&country=us"
        case .searchByMedia(let mediaType, let searchText, let limit):
            let encoded = searchText.replacingOccurrences(of: " ", with: "+")
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText
            return "/search?term=\(encoded)&media=\(mediaType)&limit=\(limit)&country=us"
        }
    }
}
