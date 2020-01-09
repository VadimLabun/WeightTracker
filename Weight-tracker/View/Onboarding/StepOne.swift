//
//  StepOne.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/16/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit

class StepOne: UIViewController {
    
    weak var delegate: NextViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
    
    @IBAction func poundsButton(_ sender: UIButton) {
        UserSettings.shared.unit = .pounds
        delegate?.goNext(viewController: self)
    }

    @IBAction func kilogramsButton(_ sender: UIButton) {
        UserSettings.shared.unit = .kilograms
        delegate?.goNext(viewController: self)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        delegate?.goNext(viewController: self)
    }
}
