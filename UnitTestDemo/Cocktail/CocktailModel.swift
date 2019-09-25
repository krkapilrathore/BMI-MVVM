//
//  CocktailModel.swift
//  UnitTestDemo
//
//  Created by kapilrathore-mbp on 26/09/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import Foundation

struct Cocktail: Decodable, Equatable {
    let id: String
    let name: String
    let instructions: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case instructions = "strInstructions"
    }
}

struct CocktailResponse: Decodable, Equatable {
    let drinks: [Cocktail]
}
