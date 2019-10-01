//
//  BMIViewModel.swift
//  UnitTestDemo
//
//  Created by kapilrathore-mbp on 25/09/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import Foundation

class BMIViewModel {
    struct Input {
        let weight: String
        let height: String
    }
    
    struct Output {
        let bmi: String
    }
    
    func transform(_ input: Input) -> Output {
        let height = (Double(input.height) ?? 0.0)/100
        let weight = Double(input.weight) ?? 0.0
        
        if weight == 0 && height == 0 { return Output(bmi: "Invalid Inputs") }
        if weight == 0 { return Output(bmi: "Invalid Weight") }
        if height == 0 { return Output(bmi: "Invalid Height") }
        return Output(bmi: "\(weight / (height * height))")
    }
}
