//
//  swift_todo_listTests.swift
//  swift-todo-listTests
//
//  Created by Ashish Kapoor on 29/08/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import XCTest
@testable import swift_todo_list

class swift_todo_listTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testTextFieldValues() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let viewController = storyboard.instantiateInitialViewController() as? UTDetailVC else {return}
        viewController.todoTF.text = "Testing..."
        let test = viewController.todoTF.text
        XCTAssertTrue(test == nil)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
