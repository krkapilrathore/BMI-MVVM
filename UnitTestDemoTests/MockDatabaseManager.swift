//
//  MockDatabaseManager.swift
//  UnitTestDemoTests
//
//  Created by kapilrathore-mbp on 01/10/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import RxSwift
@testable import UnitTestDemo

class MockDatabaseManager: DatabaseManager {
    var saveCocktailResponse: Observable<Cocktail>!
    func saveCocktail(_ cocktail: Cocktail) -> Observable<Cocktail> {
        return saveCocktailResponse
    }
    
    var getCocktailResponse: Observable<Cocktail>!
    func getCocktail() -> Observable<Cocktail> {
        return getCocktailResponse
    }
}
