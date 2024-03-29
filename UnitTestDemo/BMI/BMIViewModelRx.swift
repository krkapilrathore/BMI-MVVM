//
//  BMIViewModelRx.swift
//  UnitTestDemo
//
//  Created by kapilrathore-mbp on 01/10/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BMIViewModelRx {
    struct Input {
        let weight: Observable<String>
        let height: Observable<String>
    }
    
    struct Output {
        let bmi: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let heightInput = input.height
            .map { Double($0) ?? 0.0 }
            .map { $0/100 }
        
        let weightInput = input.weight
            .map { Double($0) ?? 0.0 }
        
        let bmiStream = Observable.combineLatest(heightInput, weightInput)
            .map { (height, weight) -> String in
                if weight == 0 && height == 0 { return "Invalid Inputs" }
                if weight == 0 { return "Invalid Weight" }
                if height == 0 { return "Invalid Height" }
                return "\(weight / (height * height))"
            }
            .asDriver(onErrorJustReturn: "Invalid")
        
        return Output(bmi: bmiStream)
    }
}
