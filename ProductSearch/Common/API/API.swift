import Foundation

// MARK: - APIURL

enum APIURL {
    case getCategories
    case searchItem(offSet: Int, searchText: String)
    case searchByCategory(offSet: Int, category: String)

    // MARK: Computed Properties

    var url: URL {
        guard let uwrappedUrl = URL(string: "https://api.mercadolibre.com/sites/MLC" + path) else {
            return URL(string: "https://api.mercadolibre.com/sites/MLC")!
        }

        return uwrappedUrl
    }
}

private extension APIURL {
    var path: String {
        switch self {
        case .getCategories:
            return "/users"
        case .searchItem(let offSet, let searchText):
            return "/search?limit=50&offset=\(offSet)&q=\(searchText.replacingOccurrences(of: " ", with: "%20"))"
        case .searchByCategory(let offSet, let category):
            return "/search?limit=50&category=\(category)&offset=\(offSet)"
        }
    }
}
