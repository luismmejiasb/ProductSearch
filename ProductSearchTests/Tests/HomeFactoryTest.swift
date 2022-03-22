//
//  HomeFactoryTest.swift
//
//  Created by Luis Mejias on 22-03-22.
//

import XCTest
@testable import ProductSearch
import UIKit

class HomeFactoryTest: XCTestCase {
    
    func testInitializeModule() {
        XCTAssertNotNil(HomeFactory.initialize())
    }
}
