//
//  HomeFactoryTest.swift
//
//  Created by Luis Mejias on 22-03-22.
//

@testable import ProductSearch
import UIKit
import XCTest

class HomeFactoryTest: XCTestCase {
    func testInitializeModule() {
        XCTAssertNotNil(HomeFactory.initialize())
    }
}
