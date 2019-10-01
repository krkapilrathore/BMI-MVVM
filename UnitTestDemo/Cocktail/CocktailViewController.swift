//
//  CocktailViewController.swift
//  UnitTestDemo
//
//  Created by kapilrathore-mbp on 26/09/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CocktailViewController: UIViewController {
    
    @IBOutlet private weak var favouriteDrinkLabel: UILabel!
    @IBOutlet private weak var currentDrinkLabel: UILabel!
    @IBOutlet private weak var instructionsLabel: UILabel!
    @IBOutlet private weak var fetchNewButton: UIButton!
    @IBOutlet private weak var setFavouriteButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let usecase = DefaultCocktailUsecase()
    
    private let viewDidLoadEvents = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewDidLoadEvents.onNext(())
    }
    
    private func bindViewModel() {
        let databaseManager = DefaultDatabaseManager()
        let cocktailUsecase = DefaultCocktailUsecase()
        let viewModel = CocktailViewModel(databaseManager, cocktailUsecase)
        
        let input = CocktailViewModel.Input.init(
            viewDidLoadEvent: viewDidLoadEvents.asObservable(),
            fetchButtonTap: fetchNewButton.rx.tap.asObservable(),
            setFavouriteButtonTap: setFavouriteButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.currentCocktail.drive(onNext: { [weak self] cocktail in
            guard let self = self else { return }
            self.currentDrinkLabel.text = cocktail.name
            self.instructionsLabel.text = cocktail.instructions
        })
        .disposed(by: disposeBag)
        
        output.favouriteDrink.drive(favouriteDrinkLabel.rx.text).disposed(by: disposeBag)
    }
}
