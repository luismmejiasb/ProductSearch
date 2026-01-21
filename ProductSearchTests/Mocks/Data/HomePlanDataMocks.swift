import Foundation
@testable import ProductSearch

// MARK: - HomeMLCDataMock

enum HomeMLCDataMock {
    case homeSearchItem

    // MARK: Computed Properties

    var data: Data {
        switch self {
        case .homeSearchItem:
            let jsonData = Data(homeSearchJsonString.utf8)
            return jsonData
        }
    }

    var searchDefaultResult: SearchResult? {
        switch self {
        case .homeSearchItem:
            do {
                let searchResultCodable = try JSONDecoder().decode(SearchResult.self, from: data)
                return searchResultCodable
            } catch {
                return nil
            }
        }
    }
}

let homeSearchJsonString = """
{
   "site_id":"MLC",
   "country_default_time_zone":"GMT-03:00",
   "query":"ipodnano",
   "paging":{
      "total":131,
      "primary_results":31,
      "offset":3,
      "limit":1
   },
   "results":[
      {
         "id":"MLC435471120",
         "site_id":"MLC",
         "title":"Case Funda Silicona iPod Nano 7 Negro Y Transparente",
         "seller":{
            "id":12341781,
            "permalink":null,
            "registration_date":null,
            "car_dealer":false,
            "real_estate_agency":false,
            "tags":null
         },
         "price":7999,
         "prices":{
            "id":"MLC435471120",
            "prices":[
               {
                  "id":"2",
                  "type":"standard",
                  "amount":7999,
                  "regular_amount":null,
                  "currency_id":"CLP",
                  "last_updated":"2021-10-19T13:15:38Z",
                  "conditions":{
                     "context_restrictions":[

                     ],
                     "start_time":null,
                     "end_time":null,
                     "eligible":true
                  },
                  "exchange_rate_context":"DEFAULT",
                  "metadata":{

                  }
               }
            ],
            "presentation":{
               "display_currency":"CLP"
            },
            "payment_method_prices":[

            ],
            "reference_prices":[

            ],
            "purchase_discounts":[

            ]
         },
         "sale_price":null,
         "currency_id":"CLP",
         "available_quantity":1,
         "sold_quantity":100,
         "buying_mode":"buy_it_now",
         "listing_type_id":"gold_special",
         "stop_time":"2040-11-06T01:41:37.000Z",
         "condition":"new",
         "permalink":"https://articulo.mercadolibre.cl/MLC-435471120-case-funda-silicona-ipod-nano-7-negro-y-transparente-_JM",
         "thumbnail":"http://http2.mlstatic.com/D_834187-MLC42363662574_062020-O.jpg",
         "thumbnail_id":"834187-MLC42363662574_062020",
         "accepts_mercadopago":true,
         "installments":{
            "quantity":6,
            "amount":1333.17,
            "rate":0,
            "currency_id":"CLP"
         },
         "address":{
            "state_id":"CL-RM",
            "state_name":"RM (Metropolitana)",
            "city_id":"TUxDQ0xBUzU2MTEz",
            "city_name":"Las Condes"
         },
         "shipping":{
            "free_shipping":false,
            "mode":"me2",
            "tags":[
               "self_service_in"
            ],
            "logistic_type":"cross_docking",
            "store_pick_up":false
         },
         "seller_address":{
            "id":"",
            "comment":"",
            "address_line":"",
            "zip_code":"",
            "country":{
               "id":"CL",
               "name":"Chile"
            },
            "state":{
               "id":"CL-RM",
               "name":"RM (Metropolitana)"
            },
            "city":{
               "id":"TUxDQ0xBUzU2MTEz",
               "name":"Las Condes"
            },
            "latitude":"",
            "longitude":""
         },
         "attributes":[
            {
               "id":"BRAND",
               "value_id":"59772",
               "value_name":"OEM",
               "values":[
                  {
                     "name":"OEM",
                     "struct":null,
                     "source":1505,
                     "id":"59772"
                  }
               ],
               "attribute_group_id":"OTHERS",
               "attribute_group_name":"Otros",
               "name":"Marca",
               "value_struct":null,
               "source":1505
            },
            {
               "id":"ITEM_CONDITION",
               "name":"Condición del ítem",
               "value_name":"Nuevo",
               "value_id":"2230284",
               "value_struct":null,
               "values":[
                  {
                     "id":"2230284",
                     "name":"Nuevo",
                     "struct":null,
                     "source":1
                  }
               ],
               "attribute_group_id":"OTHERS",
               "attribute_group_name":"Otros",
               "source":1
            }
         ],
         "original_price":null,
         "category_id":"MLC8841",
         "official_store_id":null,
         "domain_id":"MLC-ELECTRONIC_PRODUCTS",
         "catalog_product_id":null,
         "tags":[
            "good_quality_thumbnail",
            "loyalty_discount_eligible",
            "dragged_bids_and_visits",
            "good_quality_picture",
            "immediate_payment",
            "cart_eligible"
         ],
         "order_backend":1,
         "use_thumbnail_id":false,
         "offer_score":null,
         "offer_share":null,
         "match_score":null,
         "winner_item_id":null,
         "melicoin":null
      }
   ],
   "sort":{
      "id":"relevance",
      "name":"Más relevantes"
   },
   "available_sorts":[
      {
         "id":"price_asc",
         "name":"Menor precio"
      },
      {
         "id":"price_desc",
         "name":"Mayor precio"
      }
   ],
   "filters":[

   ],
   "available_filters":[
      {
         "id":"category",
         "name":"Categorías",
         "type":"text",
         "values":[
            {
               "id":"MLC1010",
               "name":"Audio",
               "results":76
            },
            {
               "id":"MLC3813",
               "name":"Accesorios para Celulares",
               "results":34
            },
            {
               "id":"MLC1648",
               "name":"Computación",
               "results":8
            },
            {
               "id":"MLC5054",
               "name":"Cables",
               "results":6
            },
            {
               "id":"MLC3690",
               "name":"Accesorios para Audio y Video",
               "results":3
            },
            {
               "id":"MLC1182",
               "name":"Instrumentos Musicales",
               "results":3
            },
            {
               "id":"MLC157652",
               "name":"Repuestos para Celulares",
               "results":3
            },
            {
               "id":"MLC3025",
               "name":"Libros, Revistas y Comics",
               "results":2
            },
            {
               "id":"MLC1071",
               "name":"Animales y Mascotas",
               "results":1
            },
            {
               "id":"MLC1039",
               "name":"Cámaras y Accesorios",
               "results":1
            },
            {
               "id":"MLC440909",
               "name":"Fundas y Bolsos",
               "results":1
            },
            {
               "id":"MLC1070",
               "name":"Otros",
               "results":1
            }
         ]
      },
      {
         "id":"official_store",
         "name":"Tiendas oficiales",
         "type":"text",
         "values":[
            {
               "id":"all",
               "name":"Todas las tiendas oficiales",
               "results":1
            },
            {
               "id":"166",
               "name":"MobileHUT",
               "results":1
            }
         ]
      },
      {
         "id":"discount",
         "name":"Descuentos",
         "type":"number",
         "values":[
            {
               "id":"5-100",
               "name":"Desde 5% OFF",
               "results":11
            },
            {
               "id":"10-100",
               "name":"Desde 10% OFF",
               "results":5
            },
            {
               "id":"15-100",
               "name":"Desde 15% OFF",
               "results":3
            },
            {
               "id":"20-100",
               "name":"Desde 20% OFF",
               "results":1
            }
         ]
      },
      {
         "id":"state",
         "name":"Ubicación",
         "type":"text",
         "values":[
            {
               "id":"CL-RM",
               "name":"RM (Metropolitana)",
               "results":112
            },
            {
               "id":"CL-CO",
               "name":"Coquimbo",
               "results":3
            },
            {
               "id":"CL-VS",
               "name":"Valparaíso",
               "results":3
            },
            {
               "id":"CL-AP",
               "name":"Arica y Parinacota",
               "results":1
            },
            {
               "id":"CL-AR",
               "name":"La Araucanía",
               "results":1
            },
            {
               "id":"CL-BI",
               "name":"Biobío",
               "results":1
            },
            {
               "id":"CL-LI",
               "name":"Libertador B. O'Higgins",
               "results":1
            },
            {
               "id":"CL-NB",
               "name":"Ñuble",
               "results":1
            }
         ]
      },
      {
         "id":"price",
         "name":"Precio",
         "type":"range",
         "values":[
            {
               "id":"*-8500.0",
               "name":"Hasta $8.500",
               "results":49
            },
            {
               "id":"8500.0-15000.0",
               "name":"$8.500 a $15.000",
               "results":48
            },
            {
               "id":"15000.0-*",
               "name":"Más de $15.000",
               "results":53
            }
         ]
      },
      {
         "id":"accepts_mercadopago",
         "name":"Filtro por MercadoPago",
         "type":"boolean",
         "values":[
            {
               "id":"yes",
               "name":"Con MercadoPago",
               "results":131
            }
         ]
      },
      {
         "id":"installments",
         "name":"Pago",
         "type":"text",
         "values":[
            {
               "id":"yes",
               "name":"En cuotas",
               "results":131
            },
            {
               "id":"no_interest",
               "name":"12 cuotas sin interés",
               "results":51
            }
         ]
      },
      {
         "id":"shipping",
         "name":"Envío",
         "type":"text",
         "values":[
            {
               "id":"mercadoenvios",
               "name":"Mercado Envíos",
               "results":125
            },
            {
               "id":"fulfillment",
               "name":"Full",
               "results":14
            }
         ]
      },
      {
         "id":"power_seller",
         "name":"Filtro por calidad de vendedores",
         "type":"boolean",
         "values":[
            {
               "id":"yes",
               "name":"Mejores vendedores",
               "results":107
            }
         ]
      },
      {
         "id":"since",
         "name":"Filtro por fecha de comienzo",
         "type":"text",
         "values":[
            {
               "id":"today",
               "name":"Publicados hoy",
               "results":1
            }
         ]
      },
      {
         "id":"has_video",
         "name":"Filtro por publicaciones con video",
         "type":"boolean",
         "values":[
            {
               "id":"yes",
               "name":"Publicaciones con video",
               "results":3
            }
         ]
      },
      {
         "id":"has_pictures",
         "name":"Filtro por publicaciones con imágenes",
         "type":"boolean",
         "values":[
            {
               "id":"yes",
               "name":"Con fotos",
               "results":131
            }
         ]
      },
      {
         "id":"price_campaign_id",
         "name":"Campaña",
         "type":"number",
         "values":[
            {
               "id":"MLC4475",
               "name":"MLC4475",
               "results":3
            },
            {
               "id":"MLC4085",
               "name":"MLC4085",
               "results":3
            },
            {
               "id":"MLC3948",
               "name":"MLC3948",
               "results":2
            },
            {
               "id":"MLC19",
               "name":"MLC19",
               "results":1
            },
            {
               "id":"MLC1231",
               "name":"MLC1231",
               "results":1
            }
         ]
      },
      {
         "id":"shipping_cost",
         "name":"Costo de envío",
         "type":"text",
         "values":[
            {
               "id":"free",
               "name":"Gratis",
               "results":43
            }
         ]
      },
      {
         "id":"ITEM_CONDITION",
         "name":"Condición",
         "type":"STRING",
         "values":[
            {
               "id":"2230284",
               "name":"Nuevo",
               "results":123
            },
            {
               "id":"2230581",
               "name":"Usado",
               "results":7
            }
         ]
      },
      {
         "id":"SHIPPING_ORIGIN",
         "name":"Tipo de compra",
         "type":"STRING",
         "values":[
            {
               "id":"10215068",
               "name":"Local",
               "results":122
            },
            {
               "id":"10215069",
               "name":"Internacional",
               "results":9
            }
         ]
      }
   ]
}
"""
