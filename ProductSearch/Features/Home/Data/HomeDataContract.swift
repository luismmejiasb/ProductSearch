    // MARK: - Local Data Source

    import Combine

    // MARK: - HomeLocalDataSourceProtocol

    protocol HomeLocalDataSourceProtocol {}

    // MARK: - HomeCloudDataSourceProtocol

    protocol HomeCloudDataSourceProtocol {
        func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error>
        func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error>
    }

    // MARK: - HomeRepositoryProtocol

    protocol HomeRepositoryProtocol {
        func searchItem(offSet: Int, searchText: String) -> Future<SearchResult, Error>
        func searchCategory(offSet: Int, category: String) -> Future<SearchResult, Error>
    }

    // MARK: - HomeCategorySearch

    enum HomeCategorySearch: Int {
        case vehicule
        case realState
        case services
        case none

        // MARK: Computed Properties

        var stringValue: String {
            switch self {
            case .vehicule:
                return "MLC1743"
            case .realState:
                return "MLC1459"
            case .services:
                return "MLC1540"
            case .none:
                return  ""
            }
        }

        var uiTitle: String {
            switch self {
            case .vehicule:
                return "Vehículos"
            case .realState:
                return "Inmuebles"
            case .services:
                return "Servicios"
            case .none:
                return ""
            }
        }
    }
