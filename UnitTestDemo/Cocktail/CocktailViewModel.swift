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
        let fetchNewCocktailEvents = Observable.merge(input.viewDidLoadEvent, input.fetchButtonTap)
        
        let cocktail = fetchNewCocktailEvents.flatMapLatest { _ in
            return self.usecase
                .fetchCocktail()
                .map { $0.drinks.first! }
                .catchError({ error -> Observable<Cocktail> in
                    return Observable.just(Cocktail(name: "Error", instructions: error.localizedDescription))
                })
            }
            .asDriver(onErrorJustReturn: Cocktail(name: "Error", instructions: "Unknown Error"))
        
        let savingInDB = input.setFavouriteButtonTap
            .do(onNext: { print("SET FAV") })
            .withLatestFrom(cocktail)
            .flatMapLatest { [weak self] cocktail -> Driver<String> in
                UserDefaults.standard.set(cocktail.name, forKey: "favouriteDrink")
                return Driver.just(cocktail.name)
            }
            .asDriver(onErrorJustReturn: "Unknown Error")
        
        let favouriteDrinkFromDB = Driver.just(UserDefaults.standard.string(forKey: "favouriteDrink") ?? "I Don't Drink!")
        
        let favouriteDrink = Driver.merge(savingInDB, favouriteDrinkFromDB)
        
        return Output(favouriteDrink: favouriteDrink, currentCocktail: cocktail)
    }
}
