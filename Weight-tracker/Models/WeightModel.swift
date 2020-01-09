//
//  WeightModel.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 10/31/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import RealmSwift

class WeightModel: Object {
    @objc dynamic var weight = 0.0
    @objc dynamic var date = Date()
    
    convenience init(weight: Double, date: Date) {
        self.init()
        self.weight = weight
        self.date = date
    }
}
