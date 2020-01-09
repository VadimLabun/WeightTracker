//
//  DataInputViewController.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 10/30/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit

class DataInputViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var picker = UIPickerView()
    
    let healthKitSetupAssistant = HealthKitSetupAssistant.assistent
    
    @IBOutlet var changesWaightLabel: UILabel!
    @IBOutlet var comfirmButton: UIButton!
    
    weak var delegate: DataInputViewControllerDelegate?
    
    var weight: Double = 80 {
        didSet {
            if UserSettings.shared.unit == .kilograms {
                kilogramsFormat()
            } else {
                poundsFormat()
            }
        }
    }
    
    func poundsFormat() {
        changesWaightLabel.text = String(format: "%.1f lb", weight * PDS_IN_KG)
    }
    
    func kilogramsFormat() {
        changesWaightLabel.text = String(format: "%.1f kg", weight)
    }
    
    //    MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = StorageManager.getLastWeight() {
            weight = item.weight
        } else {
            weight = 80
        }
        
        picker.delegate = self
        picker.dataSource = self
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)
        
        updatePicker()
        picker.isHidden = true
        pickerConstraint()
        
    }
    
    func updatePicker() {
        if UserSettings.shared.unit == .kilograms {
            picker.selectRow(Int(weight), inComponent: 0, animated: true)
            picker.selectRow(Int(Double(weight) * 10) - Int(weight) * 10, inComponent: 1, animated: true)
        } else {
            picker.selectRow(Int(weight * PDS_IN_KG), inComponent: 0, animated: true)
            picker.selectRow(Int(Double(weight * PDS_IN_KG) * 10) - Int(weight * PDS_IN_KG) * 10, inComponent: 1, animated: true)
        }
        picker.reloadAllComponents()
    }
    
    // MARK:- pickerConstraint
    
    func pickerConstraint() {
        let pickerCenter = NSLayoutConstraint(item: picker,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self.view,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0)
        
        let pickerBottom = NSLayoutConstraint(item: picker,
                                              attribute: .bottom,
                                              relatedBy: .greaterThanOrEqual,
                                              toItem: self.view,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: -50)
        
        let pickerWidth = NSLayoutConstraint(item: picker,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: 200)
        
        let pickerHieght = NSLayoutConstraint(item: picker,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: 150)
        
        self.view.addConstraints([pickerCenter, pickerBottom, pickerWidth, pickerHieght])
    }
    
    //    MARK:- @IBAction
    
    @IBAction func minusAction(_ sender: UIButton) {
        if UserSettings.shared.unit == .kilograms {
            weight -= 0.1
            kilogramsFormat()
        } else {
            weight -= 0.1
            poundsFormat()
        }
        updatePicker()
    }
    
    @IBAction func plusAction(_ sender: Any) {
        if UserSettings.shared.unit == .kilograms {
            weight += 0.1
            kilogramsFormat()
        } else {
            weight += 0.1
            poundsFormat()
        }
        updatePicker()
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        let weight = WeightModel(weight: self.weight, date: Date())
        StorageManager.saveObject(weight)
        healthKitSetupAssistant.seveWeight(weight: self.weight, date: Date())
        UserSettings.shared.oldWeight = StorageManager.getPenultimateWeight()?.weight
        delegate?.didLogWeight()
        
        self.dismiss(animated: true, completion: nil)
        picker.isHidden = true
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickerButton(_ sender: UIButton) {
        picker.isHidden = false
    }
    
    //    MARK: - UIPickerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            if UserSettings.shared.unit == Unit.kilograms {
                return 201
            } else {
                return 441
            }
        } else {
            return  10
        }
    }
    
    //    MARK: - UIPickerView Delegat
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if UserSettings.shared.unit == Unit.kilograms {
            let item1 = pickerView.selectedRow(inComponent: 0)
            let item2 = pickerView.selectedRow(inComponent: 1)
            weight = Double(item1) + (Double(item2) / 10)
        } else {
            let item1 = pickerView.selectedRow(inComponent: 0)
            let item2 = pickerView.selectedRow(inComponent: 1)
            weight = (Double(item1) + (Double(item2) / 10)) / PDS_IN_KG
        }
    }
}
