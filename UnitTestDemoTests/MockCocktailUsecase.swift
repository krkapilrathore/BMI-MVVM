//
//  MockCocktailUsecase.swift
//  UnitTestDemoTests
//
//  Created by kapilrathore-mbp on 01/10/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import RxSwift
@testable import UnitTestDemo

class MockCocktailUsecase: CocktailUsecase {
    var fetchRandomCocktailResponse: Observable<CocktailResponse>!
    func fetchRandomCocktail() -> Observable<CocktailResponse> {
        return fetchRandomCocktailResponse
    }
}
