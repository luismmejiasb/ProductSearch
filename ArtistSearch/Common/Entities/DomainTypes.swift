import Foundation

// MARK: - SearchType

/// Indicates whether a search was initiated by free text or by selecting a category.
enum SearchType {
    case text
    case category
}

// MARK: - FilterType

/// Sort options available for search results.
enum FilterType {
    case lowestPrice
    case highestPrice
}

// MARK: - CategorySearch

/// Music genre categories used to browse content via the iTunes Search API.
enum HomeCategorySearch: Int {
    case reggaeton
    case salsa
    case merengue
    case bachata
    case cumbia
    case pop
    case rock
    case jazz
    case electronica
    case hipHop
    case none

    // MARK: Computed Properties

    /// All genre cases use iTunes mediaType "music".
    var mediaType: String {
        switch self {
        case .none: return ""
        default: return "music"
        }
    }

    var uiTitle: String {
        switch self {
        case .reggaeton:   return "Reggaeton"
        case .salsa:       return "Salsa"
        case .merengue:    return "Merengue"
        case .bachata:     return "Bachata"
        case .cumbia:      return "Cumbia"
        case .pop:         return "Pop"
        case .rock:        return "Rock"
        case .jazz:        return "Jazz"
        case .electronica: return "Electrónica"
        case .hipHop:      return "Hip-Hop"
        case .none:        return ""
        }
    }
}
