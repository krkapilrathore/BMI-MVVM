//
//  BMIViewModelTests.swift
//  UnitTestDemoTests
//
//  Created by kapilrathore-mbp on 01/10/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import XCTest
@testable import UnitTestDemo

class BMIViewModelTests: XCTestCase {
    
    func test_weightFieldEmpty_heightFieldEmpty() {
        let output = getViewModelOutput(weight: "", height: "")
        // Assertion
        XCTAssertEqual(output.bmi, "Invalid Inputs")
    }
    
    func test_weightFieldValidInput_heightFieldEmpty() {
        let output = getViewModelOutput(weight: "85.0", height: "")
        // Assertion
        XCTAssertEqual(output.bmi, "Invalid Height")
    }
    
    func test_weightFieldEmpty_heightFieldValidInput() {
        // Act
        let output = getViewModelOutput(weight: "", height: "176.0")
        
        // Assertion
        XCTAssertEqual(output.bmi, "Invalid Weight")
    }
    
    func test_validWeight_validHeight() {
        let output = getViewModelOutput(weight: "90.0", height: "150")
        // Assertion
        XCTAssertEqual(output.bmi, "40.0")
    }
    
    func test_validWeight_validHeight_2() {
        let output = getViewModelOutput(weight: "100", height: "200.0")
        // Assertion
        XCTAssertEqual(output.bmi, "25.0")
    }
    
    func getViewModelOutput(weight: String, height: String) -> BMIViewModel.Output {
        let input = BMIViewModel.Input(weight: weight, height: height)
        return BMIViewModel().transform(input)
    }
}
