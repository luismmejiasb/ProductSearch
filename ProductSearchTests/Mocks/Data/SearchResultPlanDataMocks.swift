import Foundation
@testable import ProductSearch

// MARK: - SearchResultMLCDataMock

enum SearchResultMLCDataMock {
    case multipleResults
    case categoryResults
    case emptyResults

    // MARK: Computed Properties

    var data: Data {
        switch self {
        case .multipleResults:
            return Data(searchResultMultipleJsonString.utf8)
        case .categoryResults:
            return Data(searchResultCategoryJsonString.utf8)
        case .emptyResults:
            return Data(searchResultEmptyJsonString.utf8)
        }
    }

    var searchResult: SearchResult {
        do {
            return try JSONDecoder().decode(SearchResult.self, from: data)
        } catch {
            fatalError("SearchResultPlanDataMocks: JSON decoding failed — \(error)")
        }
    }
}

// MARK: - Multiple results JSON (3 items with different prices for sorting tests)

let searchResultMultipleJsonString = """
{
   "site_id": "MLC",
   "country_default_time_zone": "GMT-03:00",
   "query": "iphone",
   "paging": {
      "total": 300,
      "primary_results": 50,
      "offset": 0,
      "limit": 50
   },
   "results": [
      {
         "id": "MLC100001",
         "site_id": "MLC",
         "title": "iPhone 13 128GB",
         "seller": {
            "id": 111111,
            "permalink": null,
            "registration_date": null,
            "car_dealer": false,
            "real_estate_agency": false,
            "tags": null
         },
         "price": 600000,
         "prices": null,
         "currency_id": "CLP",
         "available_quantity": 5,
         "sold_quantity": 42,
         "buying_mode": "buy_it_now",
         "listing_type_id": "gold_special",
         "stop_time": "2040-12-01T00:00:00.000Z",
         "condition": "new",
         "permalink": "https://articulo.mercadolibre.cl/MLC-100001-iphone-13-128gb",
         "thumbnail": "http://http2.mlstatic.com/D_123456-MLC111111-001.jpg",
         "thumbnail_id": "123456-MLC111111-001",
         "accepts_mercadopago": true,
         "installments": {
            "quantity": 12,
            "amount": 50000.0,
            "rate": 0,
            "currency_id": "CLP"
         },
         "address": {
            "state_id": "CL-RM",
            "state_name": "RM (Metropolitana)",
            "city_id": "TUxDQ0xBUzU2MTEz",
            "city_name": "Santiago"
         },
         "shipping": {
            "free_shipping": true,
            "mode": "me2",
            "tags": ["fulfillment"],
            "logistic_type": "fulfillment",
            "store_pick_up": false
         },
         "seller_address": {
            "id": "",
            "comment": "",
            "address_line": "",
            "zip_code": "",
            "country": { "id": "CL", "name": "Chile" },
            "state": { "id": "CL-RM", "name": "RM (Metropolitana)" },
            "city": { "id": "TUxDQ0xBUzU2MTEz", "name": "Santiago" },
            "latitude": "",
            "longitude": ""
         },
         "attributes": [],
         "original_price": null,
         "category_id": "MLC1055",
         "official_store_id": null,
         "domain_id": "MLC-CELLPHONES",
         "catalog_product_id": null,
         "tags": ["good_quality_thumbnail"],
         "order_backend": 1,
         "use_thumbnail_id": false
      },
      {
         "id": "MLC100002",
         "site_id": "MLC",
         "title": "iPhone 12 64GB",
         "seller": {
            "id": 222222,
            "permalink": null,
            "registration_date": null,
            "car_dealer": false,
            "real_estate_agency": false,
            "tags": null
         },
         "price": 350000,
         "prices": null,
         "currency_id": "CLP",
         "available_quantity": 10,
         "sold_quantity": 88,
         "buying_mode": "buy_it_now",
         "listing_type_id": "gold_special",
         "stop_time": "2040-12-01T00:00:00.000Z",
         "condition": "used",
         "permalink": "https://articulo.mercadolibre.cl/MLC-100002-iphone-12-64gb",
         "thumbnail": "http://http2.mlstatic.com/D_123457-MLC222222-001.jpg",
         "thumbnail_id": "123457-MLC222222-001",
         "accepts_mercadopago": true,
         "installments": {
            "quantity": 6,
            "amount": 58333.0,
            "rate": 0,
            "currency_id": "CLP"
         },
         "address": {
            "state_id": "CL-RM",
            "state_name": "RM (Metropolitana)",
            "city_id": "TUxDQ0xBUzU2MTEz",
            "city_name": "Providencia"
         },
         "shipping": {
            "free_shipping": false,
            "mode": "me2",
            "tags": [],
            "logistic_type": "cross_docking",
            "store_pick_up": false
         },
         "seller_address": {
            "id": "",
            "comment": "",
            "address_line": "",
            "zip_code": "",
            "country": { "id": "CL", "name": "Chile" },
            "state": { "id": "CL-RM", "name": "RM (Metropolitana)" },
            "city": { "id": "TUxDQ0xBUzU2MTEz", "name": "Providencia" },
            "latitude": "",
            "longitude": ""
         },
         "attributes": [],
         "original_price": null,
         "category_id": "MLC1055",
         "official_store_id": null,
         "domain_id": "MLC-CELLPHONES",
         "catalog_product_id": null,
         "tags": [],
         "order_backend": 2,
         "use_thumbnail_id": false
      },
      {
         "id": "MLC100003",
         "site_id": "MLC",
         "title": "iPhone 11 128GB",
         "seller": {
            "id": 333333,
            "permalink": null,
            "registration_date": null,
            "car_dealer": false,
            "real_estate_agency": false,
            "tags": null
         },
         "price": 480000,
         "prices": null,
         "currency_id": "CLP",
         "available_quantity": 3,
         "sold_quantity": 120,
         "buying_mode": "buy_it_now",
         "listing_type_id": "gold_special",
         "stop_time": "2040-12-01T00:00:00.000Z",
         "condition": "new",
         "permalink": "https://articulo.mercadolibre.cl/MLC-100003-iphone-11-128gb",
         "thumbnail": "http://http2.mlstatic.com/D_123458-MLC333333-001.jpg",
         "thumbnail_id": "123458-MLC333333-001",
         "accepts_mercadopago": true,
         "installments": {
            "quantity": 12,
            "amount": 40000.0,
            "rate": 0,
            "currency_id": "CLP"
         },
         "address": {
            "state_id": "CL-VS",
            "state_name": "Valparaíso",
            "city_id": "TUxDQ0xBUz12345",
            "city_name": "Valparaíso"
         },
         "shipping": {
            "free_shipping": true,
            "mode": "me2",
            "tags": ["fulfillment"],
            "logistic_type": "fulfillment",
            "store_pick_up": false
         },
         "seller_address": {
            "id": "",
            "comment": "",
            "address_line": "",
            "zip_code": "",
            "country": { "id": "CL", "name": "Chile" },
            "state": { "id": "CL-VS", "name": "Valparaíso" },
            "city": { "id": "TUxDQ0xBUz12345", "name": "Valparaíso" },
            "latitude": "",
            "longitude": ""
         },
         "attributes": [],
         "original_price": null,
         "category_id": "MLC1055",
         "official_store_id": null,
         "domain_id": "MLC-CELLPHONES",
         "catalog_product_id": null,
         "tags": [],
         "order_backend": 3,
         "use_thumbnail_id": false
      }
   ],
   "sort": { "id": "relevance", "name": "Más relevantes" },
   "available_sorts": [
      { "id": "price_asc", "name": "Menor precio" },
      { "id": "price_desc", "name": "Mayor precio" }
   ],
   "filters": [],
   "available_filters": []
}
"""

// MARK: - Category search results JSON (vehicles category)

let searchResultCategoryJsonString = """
{
   "site_id": "MLC",
   "country_default_time_zone": "GMT-03:00",
   "query": null,
   "paging": {
      "total": 500,
      "primary_results": 50,
      "offset": 0,
      "limit": 50
   },
   "results": [
      {
         "id": "MLC200001",
         "site_id": "MLC",
         "title": "Toyota Corolla 2020",
         "seller": {
            "id": 444444,
            "permalink": null,
            "registration_date": null,
            "car_dealer": true,
            "real_estate_agency": false,
            "tags": null
         },
         "price": 12000000,
         "prices": null,
         "currency_id": "CLP",
         "available_quantity": 1,
         "sold_quantity": 0,
         "buying_mode": "classified",
         "listing_type_id": "gold_special",
         "stop_time": "2040-12-01T00:00:00.000Z",
         "condition": "used",
         "permalink": "https://articulo.mercadolibre.cl/MLC-200001-toyota-corolla-2020",
         "thumbnail": "http://http2.mlstatic.com/D_200001-MLC444444-001.jpg",
         "thumbnail_id": "200001-MLC444444-001",
         "accepts_mercadopago": false,
         "installments": null,
         "address": {
            "state_id": "CL-RM",
            "state_name": "RM (Metropolitana)",
            "city_id": "TUxDQ0xBUzU2MTEz",
            "city_name": "Las Condes"
         },
         "shipping": {
            "free_shipping": false,
            "mode": "not_specified",
            "tags": [],
            "logistic_type": "not_specified",
            "store_pick_up": false
         },
         "seller_address": {
            "id": "",
            "comment": "",
            "address_line": "",
            "zip_code": "",
            "country": { "id": "CL", "name": "Chile" },
            "state": { "id": "CL-RM", "name": "RM (Metropolitana)" },
            "city": { "id": "TUxDQ0xBUzU2MTEz", "name": "Las Condes" },
            "latitude": "",
            "longitude": ""
         },
         "attributes": [],
         "original_price": null,
         "category_id": "MLC1743",
         "official_store_id": null,
         "domain_id": "MLC-CARS",
         "catalog_product_id": null,
         "tags": [],
         "order_backend": 1,
         "use_thumbnail_id": false
      }
   ],
   "sort": { "id": "relevance", "name": "Más relevantes" },
   "available_sorts": [
      { "id": "price_asc", "name": "Menor precio" },
      { "id": "price_desc", "name": "Mayor precio" }
   ],
   "filters": [
      {
         "id": "category",
         "name": "Categorías",
         "type": "text",
         "values": [
            {
               "id": "MLC1743",
               "name": "Vehículos",
               "path_from_root": [{ "id": "MLC1743", "name": "Vehículos" }]
            }
         ]
      }
   ],
   "available_filters": []
}
"""

// MARK: - Empty results JSON

let searchResultEmptyJsonString = """
{
   "site_id": "MLC",
   "country_default_time_zone": "GMT-03:00",
   "query": "qwerty12345xyz",
   "paging": {
      "total": 0,
      "primary_results": 0,
      "offset": 0,
      "limit": 50
   },
   "results": [],
   "sort": { "id": "relevance", "name": "Más relevantes" },
   "available_sorts": [],
   "filters": [],
   "available_filters": []
}
"""
