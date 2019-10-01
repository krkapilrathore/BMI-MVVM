//
//  CocktailViewModelTests.swift
//  UnitTestDemoTests
//
//  Created by kapilrathore-mbp on 01/10/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
@testable import UnitTestDemo

class CocktailViewModelTests: XCTestCase {
    // DisposeBag
    var disposeBag: DisposeBag!
    // ViewModel Outputs
    var favouriteDrinkObserver: TestableObserver<String>!
    var currentCocktailObserver: TestableObserver<Cocktail>!
    // ViewModel Inputs
    var viewDidLoadInput: PublishSubject<Void>!
    var fetchButtonTapInput: PublishSubject<Void>!
    var favouriteButtonTapInput: PublishSubject<Void>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        
        let testSchedular = TestScheduler(initialClock: 0)
        favouriteDrinkObserver = testSchedular.createObserver(String.self)
        currentCocktailObserver = testSchedular.createObserver(Cocktail.self)
        
        viewDidLoadInput = PublishSubject<Void>()
        fetchButtonTapInput = PublishSubject<Void>()
        favouriteButtonTapInput = PublishSubject<Void>()
        
        let input = CocktailViewModel.Input(
            viewDidLoadEvent: viewDidLoadInput.asObservable(),
            fetchButtonTap: fetchButtonTapInput.asObservable(),
            setFavouriteButtonTap: favouriteButtonTapInput.asObservable()
        )
        
        let databaseManager = MockDatabaseManager()
        let cocktailUsecase = MockCocktailUsecase()
        let viewModel = CocktailViewModel(databaseManager, cocktailUsecase)
        
        let output = viewModel.transform(input)
        
        output.favouriteDrink.drive(favouriteDrinkObserver).disposed(by: disposeBag)
        output.currentCocktail.drive(currentCocktailObserver).disposed(by: disposeBag)
    }
    
    override func tearDown() {
        disposeBag = nil
        favouriteDrinkObserver = nil
        currentCocktailObserver = nil
        viewDidLoadInput = nil
        fetchButtonTapInput = nil
        favouriteButtonTapInput = nil
    }
    
    // MARK:- Test Suit
    func test_viewDidLoad_favouriteDrinkPresentInDB() { }
    func test_viewDidLoad_noFavouriteDrinkInDB_fetchFromUsecaseReturnsError() { }
    func test_viewDidLoad_noFavouriteDrinkInDB_fetchFromUsecaseReturnsSuccess() { }
    func test_fetchButtonTapped_fetchFromUsecaseReturnsError() { }
    func test_fetchButtonTapped_fetchFromUsecaseReturnsSuccess() { }
    func test_favouriteButtonTapped_After_fetchFromUsecaseReturnsError() { }
    func test_favouriteButtonTapped_After_fetchFromUsecaseReturnsSuccess() { }
}
