//
//  ViewController.swift
//  UnitTestDemo
//
//  Created by kapilrathore-mbp on 25/09/19.
//  Copyright © 2019 Tokopedia. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet private weak var heightField: UITextField!
    @IBOutlet private weak var weightField: UITextField!
    @IBOutlet private weak var bmiLabel: UILabel!
    
    private let viewModel = BMIViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = BMIViewModel.Input(
            weight: weightField.rx.text.map { $0 ?? "" }.asObservable(),
            height: heightField.rx.text.map { $0 ?? "" }.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.bmi.drive(bmiLabel.rx.text).disposed(by: disposeBag)
    }
}
