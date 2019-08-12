//
//  Helper.swift
//  EssentialFeedFrameworkTests
//
//  Created by Kelvin Fok on 12/8/19.
//  Copyright © 2019 Kelvin Fok. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    internal func trackForMemoryLeaks(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Potential memory leak", file: file, line: line)
        }
    }
    
}
