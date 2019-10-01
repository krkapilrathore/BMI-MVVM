//
//  DatabaseManager.swift
//  UnitTestDemo
//
//  Created by kapilrathore-mbp on 26/09/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import Foundation
import RxSwift

protocol DatabaseManager {
    func saveCocktail(_ cocktail: Cocktail) -> Observable<Cocktail>
    func getSavedCocktail() -> Observable<Cocktail>
}

class DefaultDatabaseManager: DatabaseManager {
    func saveCocktail(_ cocktail: Cocktail) -> Observable<Cocktail> {
        <#code#>
    }
    
    func getSavedCocktail() -> Observable<Cocktail> {
        <#code#>
    }
}
