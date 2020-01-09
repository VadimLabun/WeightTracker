//
//  StepThree.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/18/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit

class StepThree: UIViewController {
    
    weak var delegate: NextViewController?
    
    let notificationService = NotificationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
    }
    @IBAction func yesNotification(_ sender: UIButton) {
        notificationService.enableNotification(true) {
            self.delegate?.goNext(viewController: self)
        }
    }
    
    @IBAction func noNotification(_ sender: Any) {
        delegate?.goNext(viewController: self)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        delegate?.goNext(viewController: self)
    }
}
