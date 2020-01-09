//
//  Modul.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 10/31/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit

protocol DataInputViewControllerDelegate: class {
    func didLogWeight()
}
protocol NextViewController: class {
    func goNext(viewController: UIViewController)
}
