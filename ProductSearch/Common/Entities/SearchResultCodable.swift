//
//  HomeResultCodable.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//
import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - SearchResult

struct SearchResult: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case siteID = "site_id"
        case countryDefaultTimeZone = "country_default_time_zone"
        case query, paging, results, sort
        case availableSorts = "available_sorts"
        case filters
        case availableFilters = "available_filters"
    }

    // MARK: Properties

    let siteID, countryDefaultTimeZone, query: String?
    let paging: Paging?
    var results: [Result]?
    let sort: Sort?
    let availableSorts: [Sort]?
    let filters: [Filter]?
    let availableFilters: [AvailableFilter]?
}

// MARK: - AvailableFilter

struct AvailableFilter: Codable {
    let id, name, type: String?
    let values: [AvailableFilterValue]?
}

// MARK: - AvailableFilterValue

struct AvailableFilterValue: Codable {
    let id, name: String?
    let results: Int?
}

// MARK: - Sort

struct Sort: Codable {
    let id, name: String?
}

// MARK: - Filter

struct Filter: Codable {
    let id, name, type: String?
    let values: [FilterValue]?
}

// MARK: - FilterValue

struct FilterValue: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pathFromRoot = "path_from_root"
    }

    // MARK: Properties

    let id, name: String?
    let pathFromRoot: [Sort]?
}

// MARK: - Paging

struct Paging: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case total
        case primaryResults = "primary_results"
        case offset, limit
    }

    // MARK: Properties

    let total, primaryResults, offset, limit: Int?
}

// MARK: - Result

struct Result: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case id
        case siteID = "site_id"
        case title, price, seller, prices
        case currencyID = "currency_id"
        case availableQuantity = "available_quantity"
        case soldQuantity = "sold_quantity"
        case buyingMode = "buying_mode"
        case listingTypeID = "listing_type_id"
        case stopTime = "stop_time"
        case condition, permalink, thumbnail
        case thumbnailID = "thumbnail_id"
        case acceptsMercadopago = "accepts_mercadopago"
        case installments, address, shipping
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

    // MARK: Properties

    let id, siteID, title: String?
    let seller: Seller?
    let price: Int?
    let prices: Prices?
    let currencyID: String?
    let availableQuantity, soldQuantity: Int?
    let buyingMode, listingTypeID, stopTime, condition: String?
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
    let domainID, catalogProductID: String?
    let tags: [String]?
    let catalogListing, useThumbnailID: Bool?
    let orderBackend: Int?
}

// MARK: - Address

struct Address: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case stateID = "state_id"
        case stateName = "state_name"
        case cityID = "city_id"
        case cityName = "city_name"
    }

    // MARK: Properties

    let stateID, stateName, cityID, cityName: String?
}

// MARK: - Attribute

struct Attribute: Codable {
    // MARK: Nested Types

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

    // MARK: Properties

    let id, name, valueID: String?
    let values: [AttributeValue]?
    let valueName: String?
    let attributeGroupID, attributeGroupName: String?
    let source: Int?
}

// MARK: - AttributeValue

struct AttributeValue: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case source
        case id
        case name
    }

    // MARK: Properties

    let source: Int?
    let id, name: String?
}

// MARK: - DifferentialPricing

struct DifferentialPricing: Codable {
    let id: Int?
}

// MARK: - Installments

struct Installments: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case quantity
        case amount
        case rate
        case currencyID = "currency_id"
    }

    // MARK: Properties

    let quantity: Int?
    let amount: Double?
    let rate: Int?
    let currencyID: String?
}

// MARK: - Prices

struct Prices: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case id
        case presentation
        case prices
        case referencePrices = "reference_prices"
    }

    // MARK: Properties

    let id: String?
    let prices: [Price]?
    let presentation: Presentation?
    let referencePrices: [Price]?
}

// MARK: - Presentation

struct Presentation: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case displayCurrency = "display_currency"
    }

    // MARK: Properties

    let displayCurrency: String?
}

// MARK: - Price

struct Price: Codable {
    // MARK: Nested Types

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

    // MARK: Properties

    let id, type: String?
    let amount: Int?
    let regularAmount: Int?
    let currencyID: String?
    let lastUpdated: String?
    let conditions: Conditions?
    let exchangeRateContext: String?
    let metadata: Metadata?
}

// MARK: - Conditions

struct Conditions: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case contextRestrictions = "context_restrictions"
        case startTime = "start_time"
        case endTime = "end_time"
        case eligible
    }

    // MARK: Properties

    let contextRestrictions: [String]?
    let startTime, endTime: String?
    let eligible: Bool?
}

// MARK: - Metadata

struct Metadata: Codable {}

// MARK: - Seller

struct Seller: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case id
        case permalink
        case registrationDate = "registration_date"
        case carDealer = "car_dealer"
        case realEstateAgency = "real_estate_agency"
    }

    // MARK: Properties

    let id: Int?
    let permalink, registrationDate: String?
    let carDealer, realEstateAgency: Bool?
}

// MARK: - SellerAddress

struct SellerAddress: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case addressLine = "address_line"
        case zipCode = "zip_code"
        case country, state, city, latitude, longitude
    }

    // MARK: Properties

    let id, comment, addressLine, zipCode: String?
    let country, state, city: Sort?
    let latitude, longitude: String?
}

// MARK: - Shipping

struct Shipping: Codable {
    // MARK: Nested Types

    enum CodingKeys: String, CodingKey {
        case freeShipping = "free_shipping"
        case mode, tags
        case logisticType = "logistic_type"
        case storePickUp = "store_pick_up"
    }

    // MARK: Properties

    let freeShipping: Bool?
    let mode: String?
    let tags: [String]?
    let logisticType: String?
    let storePickUp: Bool?
}
