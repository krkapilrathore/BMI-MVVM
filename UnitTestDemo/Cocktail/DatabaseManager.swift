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
    func getCocktail() -> Observable<Cocktail>
}

class DefaultDatabaseManager: DatabaseManager {
    private let favouriteDrinkKey = "favouriteDrink"
    func saveCocktail(_ cocktail: Cocktail) -> Observable<Cocktail> {
        let cocktailData = try? JSONEncoder().encode(cocktail)
        UserDefaults.standard.set(cocktailData, forKey: favouriteDrinkKey)
        return Observable.just(cocktail)
    }
    
    func getCocktail() -> Observable<Cocktail> {
        guard let drinkData = UserDefaults.standard.data(forKey: favouriteDrinkKey),
              let drink = try? JSONDecoder().decode(Cocktail.self, from: drinkData) else {
                return Observable.just(Cocktail(id: "", name: "Error", instructions: "Could not fetch from DB"))
        }
        
        return Observable.just(drink)
    }
}
