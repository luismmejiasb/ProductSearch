import Foundation

// MARK: - Welcome

struct SearchResult: Codable {
    let siteID: String?
    let countryDefaultTimeZone: String?
    let query: String?
    let paging: Paging?
    var results: [Result]?
    let sort: Sort?
    let availableSorts: [Sort]?
    let filters: [Filter]?
    let availableFilters: [AvailableFilter]?

    enum CodingKeys: String, CodingKey {
        case siteID = "site_id"
        case countryDefaultTimeZone = "country_default_time_zone"
        case query
        case paging
        case results
        case sort
        case availableSorts = "available_sorts"
        case filters
        case availableFilters = "available_filters"
    }
}

// MARK: - AvailableFilter

struct AvailableFilter: Codable {
    let id: String?
    let name: String?
    let type: String?
    let values: [AvailableFilterValue]?
}

// MARK: - AvailableFilterValue

struct AvailableFilterValue: Codable {
    let id: String?
    let name: String?
    let results: Int?
}

// MARK: - Sort

struct Sort: Codable {
    let id: String?
    let name: String?
}

// MARK: - Filter

struct Filter: Codable {
    let id: String?
    let name: String?
    let type: String?
    let values: [FilterValue]?
}

// MARK: - FilterValue

struct FilterValue: Codable {
    let id: String?
    let name: String?
    let pathFromRoot: [Sort]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pathFromRoot = "path_from_root"
    }
}

// MARK: - Paging

struct Paging: Codable {
    let total: Int?
    let primaryResults: Int?
    let offset: Int?
    let limit: Int?

    enum CodingKeys: String, CodingKey {
        case total
        case primaryResults = "primary_results"
        case offset
        case limit
    }
}

// MARK: - Result

struct Result: Codable {
    let id: Int?
    let siteID: Int?
    let title: String?
    let seller: Seller?
    let price: Int?
    let prices: Prices?
    let currencyID: String?
    let availableQuantity: Int?
    let soldQuantity: Int?
    let buyingMode: String?
    let listingTypeID: String?
    let stopTime: String?
    let condition: String?
    let permalink: String?
    let thumbnail: String?
    let thumbnailID: String?
    let acceptsMercadopago: Bool?
    let installments: Installments?
    let address: Address?
    let shipping: Shipping?
    let sellerAddress: SellerAddress?
    let attributes: [Attribute]?
    let differentialPricing: DifferentialPricing?
    let originalPrice: Int?
    let categoryID: String?
    let officialStoreID: Int?
    let domainID: String?
    let catalogProductID: String?
    let tags: [String]?
    let catalogListing: Bool?
    let useThumbnailID: Bool?
    let orderBackend: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case siteID = "site_id"
        case title
        case price
        case seller
        case prices
        case currencyID = "currency_id"
        case availableQuantity = "available_quantity"
        case soldQuantity = "sold_quantity"
        case buyingMode = "buying_mode"
        case listingTypeID = "listing_type_id"
        case stopTime = "stop_time"
        case condition
        case permalink
        case thumbnail
        case thumbnailID = "thumbnail_id"
        case acceptsMercadopago = "accepts_mercadopago"
        case installments
        case address
        case shipping
        case sellerAddress = "seller_address"
        case attributes
        case differentialPricing = "differential_pricing"
        case originalPrice = "original_price"
        case categoryID = "category_id"
        case officialStoreID = "official_store_id"
        case domainID = "domain_id"
        case catalogProductID = "catalog_product_id"
        case tags
        case catalogListing = "catalog_listing"
        case useThumbnailID = "use_thumbnail_id"
        case orderBackend = "order_backend"
    }
}

// MARK: - Address

struct Address: Codable {
    let stateID: String?
    let stateName: String?
    let cityID: String?
    let cityName: String?

    enum CodingKeys: String, CodingKey {
        case stateID = "state_id"
        case stateName = "state_name"
        case cityID = "city_id"
        case cityName = "city_name"
    }
}

// MARK: - Attribute

struct Attribute: Codable {
    let id: String?
    let name: String?
    let valueID: String?
    let values: [AttributeValue]?
    let valueName: String?
    let attributeGroupID: String?
    let attributeGroupName: String?
    let source: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case valueID = "value_id"
        case values
        case valueName = "value_name"
        case attributeGroupID = "attribute_group_id"
        case attributeGroupName = "attribute_group_name"
        case source
    }
}

// MARK: - AttributeValue

struct AttributeValue: Codable {
    let source: Int?
    let id: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case source
        case id
        case name
    }
}

// MARK: - DifferentialPricing

struct DifferentialPricing: Codable {
    let id: Int?
}

// MARK: - Installments

struct Installments: Codable {
    let quantity: Int?
    let amount: Double?
    let rate: Int?
    let currencyID: String?

    enum CodingKeys: String, CodingKey {
        case quantity
        case amount
        case rate
        case currencyID = "currency_id"
    }
}

// MARK: - Prices

struct Prices: Codable {
    let id: String?
    let prices: [Price]?
    let presentation: Presentation?
    let referencePrices: [Price]?

    enum CodingKeys: String, CodingKey {
        case id
        case presentation
        case prices
        case referencePrices = "reference_prices"
    }
}

// MARK: - Presentation

struct Presentation: Codable {
    let displayCurrency: String?

    enum CodingKeys: String, CodingKey {
        case displayCurrency = "display_currency"
    }
}

// MARK: - Price

struct Price: Codable {
    let id: String?
    let type: String?
    let amount: Int?
    let regularAmount: Int?
    let currencyID: String?
    let lastUpdated: String?
    let conditions: Conditions?
    let exchangeRateContext: String?
    let metadata: Metadata?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case amount
        case regularAmount = "regular_amount"
        case currencyID = "currency_id"
        case lastUpdated = "last_updated"
        case conditions
        case exchangeRateContext = "exchange_rate_context"
        case metadata
    }
}

// MARK: - Conditions

struct Conditions: Codable {
    let contextRestrictions: [String]?
    let startTime: String?
    let endTime: String?
    let eligible: Bool?

    enum CodingKeys: String, CodingKey {
        case contextRestrictions = "context_restrictions"
        case startTime = "start_time"
        case endTime = "end_time"
        case eligible
    }
}

// MARK: - Metadata

struct Metadata: Codable {}

// MARK: - Seller

struct Seller: Codable {
    let id: Int?
    let permalink: String?
    let registrationDate: String?
    let carDealer: Bool?
    let realEstateAgency: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case permalink
        case registrationDate = "registration_date"
        case carDealer = "car_dealer"
        case realEstateAgency = "real_estate_agency"
    }
}

// MARK: - SellerAddress

struct SellerAddress: Codable {
    let id: String?
    let comment: String?
    let addressLine: String?
    let zipCode: String?
    let country: Sort?
    let state: Sort?
    let city: Sort?
    let latitude: String?
    let longitude: String?

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case addressLine = "address_line"
        case zipCode = "zip_code"
        case country
        case state
        case city
        case latitude
        case longitude
    }
}

// MARK: - Shipping

struct Shipping: Codable {
    let freeShipping: Bool?
    let mode: String?
    let tags: [String]?
    let logisticType: String?
    let storePickUp: Bool?

    enum CodingKeys: String, CodingKey {
        case freeShipping = "free_shipping"
        case mode
        case tags
        case logisticType = "logistic_type"
        case storePickUp = "store_pick_up"
    }
}
