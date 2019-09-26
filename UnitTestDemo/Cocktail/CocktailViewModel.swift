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
        
        let cocktailFetchedOnLoad = input.viewDidLoadEvent
            .flatMap({ _ -> Observable<Cocktail> in
                guard let drinkData = UserDefaults.standard.data(forKey: "favouriteDrink"),
                    let cocktail = try? JSONDecoder().decode(Cocktail.self, from: drinkData) else {
                        return Observable.just(Cocktail(id: "", name: "Error", instructions: "Could not fetch from DB"))
                }
                return Observable.just(cocktail)
            })
            .flatMap { cocktail -> Observable<Cocktail> in
                if cocktail.id.isEmpty {
                    return newRandomCocktail
                }
                return Observable.just(cocktail)
            }
            .asDriver(onErrorJustReturn: Cocktail(id: "", name: "Error", instructions: "Unknown Error"))
        
        let fetchButtonCocktail = input.fetchButtonTap
            .flatMapLatest { _ in return newRandomCocktail }
            .asDriver(onErrorJustReturn: Cocktail(id: "", name: "Error", instructions: "Unknown Error"))
        
        let currentCocktail = Driver.merge(fetchButtonCocktail, cocktailFetchedOnLoad)
        
        let savingInDB = input.setFavouriteButtonTap
            .withLatestFrom(currentCocktail)
            .flatMapLatest { cocktail -> Driver<String> in
                let drinkData = try? JSONEncoder().encode(cocktail)
                UserDefaults.standard.set(drinkData, forKey: "favouriteDrink")
                return Driver.just(cocktail.name)
            }
            .asDriver(onErrorJustReturn: "Unknown Error")
        
        let favouriteDrinkFromDB = input.viewDidLoadEvent
            .flatMap({ _ -> Observable<String> in
                guard let drinkData = UserDefaults.standard.data(forKey: "favouriteDrink"),
                    let cocktail = try? JSONDecoder().decode(Cocktail.self, from: drinkData) else {
                        return Observable.just("Error on fetch from DB")
                }
                return Observable.just(cocktail.name)
            })
            .asDriver(onErrorJustReturn: "I Don't Drink!")
        
        let favouriteDrink = Driver.merge(savingInDB, favouriteDrinkFromDB)
        
        return Output(favouriteDrink: favouriteDrink, currentCocktail: currentCocktail)
    }
}
