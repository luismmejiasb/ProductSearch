//
//  TransactionResult.swift
//  ProductSearchTests
//
//  Created by Luis Mejias on 22-03-22.
//

import Foundation

enum TransactionStatus {
    case success, failure, nilValue
}

enum CloudSourceMockError: LocalizedError {
    case nilValue, unknow
}

enum RepositoryMockError: LocalizedError {
    case nilValue, unknow
}
