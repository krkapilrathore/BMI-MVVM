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
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let fetchButtonTap: Observable<Void>
        let setFavouriteButtonTap: Observable<Void>
    }
    
    struct Output {
        let favouriteDrink: Driver<String>
        let currentCocktail: Driver<Cocktail>
    }
    
    private let databaseManager: DatabaseManager
    private let cocktailUsecase: CocktailUsecase
    init(_ databaseManager: DatabaseManager, _ cocktailUsecase: CocktailUsecase) {
        self.databaseManager = databaseManager
        self.cocktailUsecase = cocktailUsecase
    }
    
    func transform(_ input: Input) -> Output {
        
        let newRandomCocktail = self.cocktailUsecase
            .fetchRandomCocktail()
            .map { $0.drinks.first! }
            .catchError({ error -> Observable<Cocktail> in
                return Observable.just(Cocktail(id: "", name: "Error", instructions: error.localizedDescription))
            })
        
        let cocktailFetchedOnLoad = input.viewDidLoadEvent
            .flatMap({ _  in return self.databaseManager.getCocktail() })
            .flatMap { cocktail -> Observable<Cocktail> in
                if cocktail.id.isEmpty { return newRandomCocktail }
                return Observable.just(cocktail)
            }
            .asDriver(onErrorJustReturn: Cocktail(id: "", name: "Error", instructions: "Unknown Error"))
        
        let fetchButtonCocktail = input.fetchButtonTap
            .flatMapLatest { _ in return newRandomCocktail }
            .asDriver(onErrorJustReturn: Cocktail(id: "", name: "Error", instructions: "Unknown Error"))
        
        let currentCocktail = Driver.merge(fetchButtonCocktail, cocktailFetchedOnLoad)
        
        let savingInDB = input.setFavouriteButtonTap
            .withLatestFrom(currentCocktail)
            .flatMapLatest { self.databaseManager.saveCocktail($0) }
            .map { $0.name }
            .asDriver(onErrorJustReturn: "Unknown Error")
        
        let favouriteDrinkFromDB = input.viewDidLoadEvent
            .flatMap({ _  in return self.databaseManager.getCocktail() })
            .map({ cocktail -> String in
                if cocktail.id.isEmpty { return "I Don't Drink!" }
                return cocktail.name
            })
            .asDriver(onErrorJustReturn: "I Don't Drink!")
        
        let favouriteDrink = Driver.merge(savingInDB, favouriteDrinkFromDB)
        
        return Output(favouriteDrink: favouriteDrink, currentCocktail: currentCocktail)
    }
}
