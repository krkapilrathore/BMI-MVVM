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
    func fetchCocktail() -> Observable<CocktailResponse>
}

class DefaultCocktailUsecase: CocktailUsecase {
    private let provider = MoyaProvider<CocktailTarget>()
    
    func fetchCocktail() -> Observable<CocktailResponse> {
        return provider.rx
            .request(.getRandom)
            .do(
                onSuccess: { print("API Response", $0)},
                onError: { print("API Error", $0)},
                onSubscribed: { print("API Subs") },
                onDispose: { print("API Disposed") }
            )
            .map(CocktailResponse.self)
            .asObservable()
    }
}

