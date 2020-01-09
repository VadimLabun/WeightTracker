//
//  StorageManager.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 10/31/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import RealmSwift


class StorageManager {
    
    static func saveObject(_ weight: WeightModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(weight)
        }
    }
    
    static func deleteObject(_ weight: WeightModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(weight)
        }
    }
    
    static func getLastWeight() -> WeightModel? {
        let realm = try! Realm()
        let items = realm.objects(WeightModel.self).sorted(byKeyPath: "date", ascending: false)
        return items.first
    }
    
    static func getAllWeights() -> Results<WeightModel>? {
        let realm = try! Realm()
        let weights = realm.objects(WeightModel.self)
        return weights
    }
    
    static func getPenultimateWeight() -> WeightModel? {
        let realm = try! Realm()
        let items = realm.objects(WeightModel.self).sorted(byKeyPath: "date", ascending: false)
        
        guard items.count > 1 else { return nil }
        return items[1]
    }
}
