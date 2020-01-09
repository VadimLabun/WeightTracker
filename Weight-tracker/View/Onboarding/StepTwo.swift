//
//  StepTwo.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/16/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit

class StepTwo: UIViewController {
    
    weak var delegate: NextViewController?
    
    let healthKitSetupAssistant = HealthKitSetupAssistant.assistent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
    }
    
    @IBAction func yesHealthButton(_ sender: UIButton) {
        healthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                self.delegate?.goNext(viewController: self)
                return
            }
            print("HealthKit Successfully Authorized.")
            self.delegate?.goNext(viewController: self)
        }

    }
    
    @IBAction func noHealthButton(_ sender: Any) {
        delegate?.goNext(viewController: self)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        delegate?.goNext(viewController: self)
    }
    
}
