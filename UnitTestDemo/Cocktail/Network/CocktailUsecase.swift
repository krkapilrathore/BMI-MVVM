//
//  CocktailUsecase.swift
//  UnitTestDemo
//
//  Created by kapilrathore-mbp on 26/09/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol CocktailUsecase {
    func fetchRandomCocktail() -> Observable<CocktailResponse>
    func fetchCocktailById(_ id: String) -> Observable<CocktailResponse>
}

class DefaultCocktailUsecase: CocktailUsecase {
    private let provider = MoyaProvider<CocktailTarget>()
    
    func fetchRandomCocktail() -> Observable<CocktailResponse> {
        return provider.rx
            .request(.getRandom)
            .map(CocktailResponse.self)
            .asObservable()
    }
    
    func fetchCocktailById(_ id: String) -> Observable<CocktailResponse> {
        return provider.rx
            .request(.getById(id))
            .map(CocktailResponse.self)
            .asObservable()
    }
}

