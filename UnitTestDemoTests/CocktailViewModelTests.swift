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

    let databaseManager = MockDatabaseManager()
    let cocktailUsecase = MockCocktailUsecase()
    
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
    func test_viewDidLoad_favouriteDrinkPresentInDB() {
        // Given
        let dummyCocktail = Cocktail(id: "123", name: "Dummy Cocktail", instructions: "Some instructions.")
        databaseManager.getCocktailResponse = Observable.just(dummyCocktail)
        
        // When
        viewDidLoadInput.onNext(())
        
        // Then
        XCTAssertEqual(favouriteDrinkObserver.events, [.next(0, "Dummy Cocktail")])
        XCTAssertEqual(currentCocktailObserver.events, [.next(0, dummyCocktail)])
    }
    
    func test_viewDidLoad_noFavouriteDrinkInDB_fetchFromUsecaseReturnsError() {
        
        // Given
        databaseManager.getCocktailResponse = Observable.just(Cocktail(id: "", name: "Error", instructions: "Could not fetch from DB"))
        let networkError = APIError.networkError
        cocktailUsecase.fetchRandomCocktailResponse = Observable.error(networkError)
        
        // When
        viewDidLoadInput.onNext(())
        
        // Then
        XCTAssertEqual(favouriteDrinkObserver.events, [.next(0, "I Don't Drink!")])
        XCTAssertEqual(currentCocktailObserver.events, [.next(0, Cocktail(id: "", name: "Error", instructions: "API Error"))])
    }
    
    func test_viewDidLoad_noFavouriteDrinkInDB_fetchFromUsecaseReturnsSuccess() { }
    func test_fetchButtonTapped_fetchFromUsecaseReturnsError() { }
    func test_fetchButtonTapped_fetchFromUsecaseReturnsSuccess() { }
    func test_favouriteButtonTapped_After_fetchFromUsecaseReturnsError() { }
    func test_favouriteButtonTapped_After_fetchFromUsecaseReturnsSuccess() { }
}

enum APIError: Error {
    case networkError
    
    var localizedDescription: String {
        return "API Error"
    }
}
