//
//  UnitTestDemoTests.swift
//  UnitTestDemoTests
//
//  Created by kapilrathore-mbp on 25/09/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
@testable import UnitTestDemo

class UnitTestDemoTests: XCTestCase {
    
    var testObserver: TestableObserver<String>!
    var disposeBag: DisposeBag!
    var weightInput: PublishSubject<String>!
    var heightInput: PublishSubject<String>!
    
    override func setUp() {
        testObserver = TestScheduler(initialClock: 0).createObserver(String.self)
        disposeBag = DisposeBag()
        weightInput = PublishSubject<String>()
        heightInput = PublishSubject<String>()
        
        let viewModel: BMIViewModel = BMIViewModel()
        let input = BMIViewModel.Input(weight: weightInput.asObserver(), height: heightInput.asObserver())
        let output = viewModel.transform(input)
        
        output.bmi.drive(testObserver).disposed(by: disposeBag)
    }
    
    func test_weightFieldEmpty_heightFieldEmpty() {
        // Act
        weightInput.onNext("")
        heightInput.onNext("")
        
        // Assert
        let expectedEvents = [
            Recorded.next(0, "Invalid Inputs")
        ]
        XCTAssertEqual(testObserver.events, expectedEvents)
    }
    
    func test_weightFieldValidInput_heightFieldEmpty() {
        // Act
        weightInput.onNext("85.5")
        heightInput.onNext("")
        
        // Assert
        let expectedEvents = [
            Recorded.next(0, "Invalid Height")
        ]
        XCTAssertEqual(testObserver.events, expectedEvents)
    }
    
    func test_weightFieldEmpty_heightFieldValidInput() {
        // Act
        weightInput.onNext("")
        heightInput.onNext("176")
        
        // Assert
        let expectedEvents = [
            Recorded.next(0, "Invalid Weight")
        ]
        XCTAssertEqual(testObserver.events, expectedEvents)
    }
    
    func test_validWeight_validHeight() {
        weightInput.onNext("90")
        heightInput.onNext("150")
        
        // Assert
        let expectedEvents = [
            Recorded.next(0, "40.0")
        ]
        XCTAssertEqual(testObserver.events, expectedEvents)
    }
    
    func test_validWeight_validHeight_2() {
        weightInput.onNext("100")
        heightInput.onNext("200")
        
        // Assert
        let expectedEvents = [
            Recorded.next(0, "25.0")
        ]
        XCTAssertEqual(testObserver.events, expectedEvents)
    }
}
