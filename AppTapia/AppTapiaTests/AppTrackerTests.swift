//
//  AppTapiaTests.swift
//  AppTapiaTests
//
//  Created by Andy on 10/09/17.
//

import XCTest
@testable import AppTapia

class AppTrackerTests: XCTestCase {
    
    //MARK: Tapia App Class Tests
    
    // Confirm that the Tapia initializer returns a Entry object when passed valid parameters.
    func testEntryInitializationSucceeds() {
        
        // Test 1
        let zeroRatingMeal = Contact.init(name: "Andy", photo: nil)
        XCTAssertNotNil(zeroRatingMeal)
        
    }
    
    // Confirm that the initialier returns nil when passed a negative rating or an empty name.
    func testEntryInitializationFails() {
        
        // Empty String
        let emptyStringMeal = Contact.init(name: "", photo: nil)
        XCTAssertNil(emptyStringMeal)
        
    }
}
