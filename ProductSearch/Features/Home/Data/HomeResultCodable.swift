//
//  HomeResultCodable.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//
import Foundation

// MARK: - Welcome
struct HomeResultCodable: Codable {
    let siteID, countryDefaultTimeZone, query: String
    let paging: Paging
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case siteID = "site_id"
        case countryDefaultTimeZone = "country_default_time_zone"
        case query, paging, results
    }
}

// MARK: - Paging
struct Paging: Codable {
    let total, primaryResults, offset, limit: Int

    enum CodingKeys: String, CodingKey {
        case total
        case primaryResults = "primary_results"
        case offset, limit
    }
}

// MARK: - Result
struct Result: Codable {
    let id, siteID, title: String
    let seller: Seller
    let price: Int
    let prices: Prices
    let salePrice: JSONNull?
    let currencyID: String
    let availableQuantity, soldQuantity: Int
    let buyingMode, listingTypeID, stopTime, condition: String
    let permalink: String
    let thumbnail: String
    let thumbnailID: String
    let acceptsMercadopago: Bool
    let installments: Installments
    let address: Address
    let shipping: Shipping
    let sellerAddress: SellerAddress
    let attributes: [Attribute]
    let originalPrice: JSONNull?
    let categoryID: String
    let officialStoreID: JSONNull?
    let domainID: String
    let catalogProductID: JSONNull?
    let tags: [String]
    let orderBackend: Int
    let useThumbnailID: Bool
    let offerScore, offerShare, matchScore, winnerItemID: JSONNull?
    let melicoin: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id
        case siteID = "site_id"
        case title, seller, price, prices
        case salePrice = "sale_price"
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
        case originalPrice = "original_price"
        case categoryID = "category_id"
        case officialStoreID = "official_store_id"
        case domainID = "domain_id"
        case catalogProductID = "catalog_product_id"
        case tags
        case orderBackend = "order_backend"
        case useThumbnailID = "use_thumbnail_id"
        case offerScore = "offer_score"
        case offerShare = "offer_share"
        case matchScore = "match_score"
        case winnerItemID = "winner_item_id"
        case melicoin
    }
}

// MARK: - Address
struct Address: Codable {
    let stateID, stateName, cityID, cityName: String

    enum CodingKeys: String, CodingKey {
        case stateID = "state_id"
        case stateName = "state_name"
        case cityID = "city_id"
        case cityName = "city_name"
    }
}

// MARK: - Attribute
struct Attribute: Codable {
    let valueName: String
    let valueStruct: JSONNull?
    let attributeGroupName: String
    let source: Int
    let id: String
    let valueID: String?
    let attributeGroupID, name: String
    let values: [Value]

    enum CodingKeys: String, CodingKey {
        case valueName = "value_name"
        case valueStruct = "value_struct"
        case attributeGroupName = "attribute_group_name"
        case source, id
        case valueID = "value_id"
        case attributeGroupID = "attribute_group_id"
        case name, values
    }
}

// MARK: - Value
struct Value: Codable {
    let id: String?
    let name: String
    let valueStruct: JSONNull?
    let source: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case valueStruct = "struct"
        case source
    }
}

// MARK: - Installments
struct Installments: Codable {
    let quantity: Int
    let amount, rate: Double
    let currencyID: String

    enum CodingKeys: String, CodingKey {
        case quantity, amount, rate
        case currencyID = "currency_id"
    }
}

// MARK: - Prices
struct Prices: Codable {
    let id: String
    let prices: [Price]
    let presentation: Presentation
    let paymentMethodPrices: [JSONAny]
    let referencePrices: [Price]
    let purchaseDiscounts: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case id, prices, presentation
        case paymentMethodPrices = "payment_method_prices"
        case referencePrices = "reference_prices"
        case purchaseDiscounts = "purchase_discounts"
    }
}

// MARK: - Presentation
struct Presentation: Codable {
    let displayCurrency: String

    enum CodingKeys: String, CodingKey {
        case displayCurrency = "display_currency"
    }
}

// MARK: - Price
struct Price: Codable {
    let id, type: String
    let amount: Int
    let regularAmount: JSONNull?
    let currencyID: String
    let lastUpdated: Date
    let conditions: Conditions
    let exchangeRateContext: String
    let metadata: Metadata?
    let tags: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id, type, amount
        case regularAmount = "regular_amount"
        case currencyID = "currency_id"
        case lastUpdated = "last_updated"
        case conditions
        case exchangeRateContext = "exchange_rate_context"
        case metadata, tags
    }
}

// MARK: - Conditions
struct Conditions: Codable {
    let contextRestrictions: [String]
    let startTime, endTime: JSONNull?
    let eligible: Bool

    enum CodingKeys: String, CodingKey {
        case contextRestrictions = "context_restrictions"
        case startTime = "start_time"
        case endTime = "end_time"
        case eligible
    }
}

// MARK: - Metadata
struct Metadata: Codable {
}

// MARK: - Seller
struct Seller: Codable {
    let id: Int
    let permalink: String
    let registrationDate: String
    let carDealer, realEstateAgency: Bool
    let tags: [String]
    let sellerReputation: SellerReputation

    enum CodingKeys: String, CodingKey {
        case id, permalink
        case registrationDate = "registration_date"
        case carDealer = "car_dealer"
        case realEstateAgency = "real_estate_agency"
        case tags
        case sellerReputation = "seller_reputation"
    }
}

// MARK: - SellerReputation
struct SellerReputation: Codable {
    let powerSellerStatus: JSONNull?
    let levelID: String
    let metrics: Metrics
    let transactions: Transactions

    enum CodingKeys: String, CodingKey {
        case powerSellerStatus = "power_seller_status"
        case levelID = "level_id"
        case metrics, transactions
    }
}

// MARK: - Metrics
struct Metrics: Codable {
    let cancellations, claims, delayedHandlingTime: Cancellations
    let sales: Sales

    enum CodingKeys: String, CodingKey {
        case cancellations, claims
        case delayedHandlingTime = "delayed_handling_time"
        case sales
    }
}

// MARK: - Cancellations
struct Cancellations: Codable {
    let period: String
    let rate: Double
    let value: Int
}

// MARK: - Sales
struct Sales: Codable {
    let period: String
    let completed: Int
}

// MARK: - Transactions
struct Transactions: Codable {
    let canceled: Int
    let period: String
    let total: Int
    let ratings: Ratings
    let completed: Int
}

// MARK: - Ratings
struct Ratings: Codable {
    let negative: Int
    let neutral, positive: Double
}

// MARK: - SellerAddress
struct SellerAddress: Codable {
    let id, comment, addressLine, zipCode: String
    let country, state, city: City
    let latitude, longitude: String

    enum CodingKeys: String, CodingKey {
        case id, comment
        case addressLine = "address_line"
        case zipCode = "zip_code"
        case country, state, city, latitude, longitude
    }
}

// MARK: - City
struct City: Codable {
    let id, name: String
}

// MARK: - Shipping
struct Shipping: Codable {
    let freeShipping: Bool
    let mode: String
    let tags: [JSONAny]
    let logisticType: String
    let storePickUp: Bool

    enum CodingKeys: String, CodingKey {
        case freeShipping = "free_shipping"
        case mode, tags
        case logisticType = "logistic_type"
        case storePickUp = "store_pick_up"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
