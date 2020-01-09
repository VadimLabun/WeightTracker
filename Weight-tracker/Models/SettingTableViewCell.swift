//
//  SettingTableViewCell.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/4/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet var settingLabel: UILabel!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var switcher: UISwitch!
    @IBOutlet var waitingIndicator: UIActivityIndicatorView!
    @IBOutlet var heightLabel: UILabel!
}
