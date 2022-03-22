//
//  HomeLocalDataSourceMock.swift
//  Alamofire
//
//  Created by Luis Mejias on 22-03-22.
//

import Foundation
@testable import ProductSearch

class HomeLocalDataSourceMock: HomeLocalDataSourceProtocol {
    var status: TransactionStatus = .success

    init() {}
}
