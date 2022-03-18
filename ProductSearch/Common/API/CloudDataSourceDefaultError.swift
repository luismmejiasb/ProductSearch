//
//  HomeCloudDataSourceDefaultError.swift
//  ProductSearch
//
//  Created by Luis Mejias on 15-03-22.
//

import Foundation

enum CloudDataSourceDefaultError: Error {
    case unwrappableValue
    case responseCannotBeParsed
    case httpError(code: Int, message: String)
}
