//
//  StepFour.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/18/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit

class StepFour: UIViewController {
    
    var delegate: NextViewController! = nil
    
    var weight: Double = 0
    
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupToHideKeyboardOnTapOnView()
        
        view.backgroundColor = .brown
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        guard
            let textWeight = weightTextField.text,
            let textHeight = heightTextField.text,
            let weight = Double(textWeight),
            let height = Int(textHeight)
            else { return alertError() }
        
        self.weight = weight
        
        let weightmodel = WeightModel(weight: self.weight, date: Date())
        StorageManager.saveObject(weightmodel)
        
        UserSettings.shared.height = height
        
        weightTextField.text?.removeAll()
        heightTextField.text?.removeAll()
        delegate.goNext(viewController: self)
    }
    
    func alertError() {
        let ac = UIAlertController(title: R.string.locolazible.settingsItemError(),
                                   message: R.string.locolazible.settingsItemInvalidInputFormat(),
                                   preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: R.string.locolazible.settingsItemOk(),
                                     style: .default,
                                     handler: nil)
        
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
    
}

extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
