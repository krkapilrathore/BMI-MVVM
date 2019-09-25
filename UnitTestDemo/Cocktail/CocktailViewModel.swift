//
//  CocktailViewModel.swift
//  UnitTestDemo
//
//  Created by kapilrathore-mbp on 26/09/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CocktailViewModel {
    private let usecase = DefaultCocktailUsecase()
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let fetchButtonTap: Observable<Void>
        let setFavouriteButtonTap: Observable<Void>
    }
    
    struct Output {
        let favouriteDrink: Driver<String>
        let currentCocktail: Driver<Cocktail>
    }
    
    func transform(_ input: Input) -> Output {
        
        let newRandomCocktail = self.usecase
            .fetchRandomCocktail()
            .map { $0.drinks.first! }
            .catchError({ error -> Observable<Cocktail> in
                return Observable.just(Cocktail(id: "", name: "Error", instructions: error.localizedDescription))
            })
        
        let cocktailFetchedOnLoad = input.viewDidLoadEvent.flatMap { _ -> Observable<Cocktail> in
            if let drinkId = UserDefaults.standard.string(forKey: "favouriteDrinkId") {
                return self.usecase
                    .fetchCocktailById(drinkId)
                    .map { $0.drinks.first! }
                    .catchError({ error -> Observable<Cocktail> in
                        return Observable.just(Cocktail(id: "", name: "Error", instructions: error.localizedDescription))
                    })
            }
            
            return newRandomCocktail
        }
        .asDriver(onErrorJustReturn: Cocktail(id: "", name: "Error", instructions: "Unknown Error"))
        
        
        let fetchButtonCocktail = input.fetchButtonTap
            .flatMapLatest { _ in return newRandomCocktail }
            .asDriver(onErrorJustReturn: Cocktail(id: "", name: "Error", instructions: "Unknown Error"))
        
        let currentCocktail = Driver.merge(fetchButtonCocktail, cocktailFetchedOnLoad)
        
        let savingInDB = input.setFavouriteButtonTap
            .do(onNext: { print("SET FAV") })
            .withLatestFrom(currentCocktail)
            .flatMapLatest { [weak self] cocktail -> Driver<String> in
                UserDefaults.standard.set(cocktail.id, forKey: "favouriteDrinkId")
                UserDefaults.standard.set(cocktail.name, forKey: "favouriteDrink")
                return Driver.just(cocktail.name)
            }
            .asDriver(onErrorJustReturn: "Unknown Error")
        
        let favouriteDrinkFromDB = Driver.just(UserDefaults.standard.string(forKey: "favouriteDrink") ?? "I Don't Drink!")
        
        let favouriteDrink = Driver.merge(savingInDB, favouriteDrinkFromDB)
        
        return Output(favouriteDrink: favouriteDrink, currentCocktail: currentCocktail)
    }
}
