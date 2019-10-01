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
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
//        setupReactiveViewModel()
    }
    
    private func setupViewModel() {
        heightField.addTarget(self, action: #selector(fieldValueChanged(_:)), for: .editingChanged)
        weightField.addTarget(self, action: #selector(fieldValueChanged(_:)), for: .editingChanged)
    }
    
    @objc func fieldValueChanged(_ textField: UITextField) {
        var heightInput = heightField.text ?? ""
        var weightInput = weightField.text ?? ""
        
        if textField == heightField { heightInput = textField.text ?? "" }
        if textField == weightField { weightInput = textField.text ?? "" }
        
        let viewModelInput = BMIViewModel.Input(weight: weightInput, height: heightInput)
        let viewModel = BMIViewModel()
        let output = viewModel.transform(viewModelInput)
        bmiLabel.text = output.bmi
    }
    
//    private func setupReactiveViewModel() {
//        let input = BMIViewModelRx.Input(
//            weight: weightField.rx.text.map { $0 ?? "" }.asObservable(),
//            height: heightField.rx.text.map { $0 ?? "" }.asObservable()
//        )
//
//        let output = BMIViewModelRx().transform(input)
//        output.bmi.drive(bmiLabel.rx.text).disposed(by: disposeBag)
//    }
}
