//
//  StepZero.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/16/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit

class StepZero: UIViewController {
    
    weak var delegate: NextViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        delegate?.goNext(viewController: self)
    }
    
}
