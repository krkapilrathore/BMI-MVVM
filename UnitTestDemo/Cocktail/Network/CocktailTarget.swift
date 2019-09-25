//
//  CocktailTarget.swift
//  UnitTestDemo
//
//  Created by kapilrathore-mbp on 26/09/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import Moya

enum CocktailTarget {
    case getRandom
}

extension CocktailTarget: TargetType {
    
    var task: Task { return .requestPlain }
    
    var baseURL: URL { return URL(string: "https://www.thecocktaildb.com/api/json/v1/1")! }
    
    var path: String { return "/random.php" }
    
    var method: Method { return .get }
    
    var sampleData: Data { return Data() }
    
    private var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    var headers: [String : String]? { return nil }
}
