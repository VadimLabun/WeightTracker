//
//  ViewController.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 10/30/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, DataInputViewControllerDelegate {
    
    var weight: Double? {
        didSet {
            if UserSettings.shared.unit == Unit.kilograms {
                kilogramsFormat()
            } else {
                poundsFormat()
            }
        }
    }
    
    var date: Date? {
        didSet {
            if let date = date {
                dateLabel.text = dateFormater.string(from: date)
            } else {
                dateLabel.text = "--"
            }
        }
    }
    
    var height: Double? {
        didSet {
            if let height = height {
                heightLabel.text = R.string.locolazible.settingsItemTextHeightCm(height)
            } else {
                heightLabel.text = "--"
            }
        }
    }
    
    var bmi: Double? {
        didSet {
            if let bmi = bmi {
                bmiLabel.text = String(format: "\(R.string.locolazible.settingsItemBmi()) %.1f", bmi )
                HealthKitSetupAssistant.assistent.seveBodyMassIndex(bodyMassIndex: bmi, date: Date())
            } else {
                bmiLabel.text = "--"
            }
        }
    }
    
    var bmiClassification: String {
        if let bmi = bmi {
            switch bmi {
            case 0..<16.0:
                return R.string.locolazible.settingsItemPronouncedDeficitOfBodyWeight()
            case 16.0..<18.5:
                return R.string.locolazible.settingsItemLowBodyWeight()
            case 18.5..<25:
                return R.string.locolazible.settingsItemNormalBodyWeight()
            case 25..<30:
                return R.string.locolazible.settingsItemOverweightPreObesity()
            case 30..<35:
                return R.string.locolazible.settingsItemTheObesityOfThe1stDegree()
            case 35..<40:
                return R.string.locolazible.settingsItemTheObesityOfThe2stDegree()
            case 40..<200:
                return R.string.locolazible.settingsItemTheObesityOfThe3stDegree()
            default:
                return ""
            }
        } else {
            return R.string.locolazible.settingsItemAddData()
        }
    }
    
    let dateFormater: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMM yyyy HH:mm"
        return df
    }()
    
    @IBOutlet var waightDetaView: UIView!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var logWaightButton: UIButton!
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var bmiLabel: UILabel!
    @IBOutlet var bmiMessageLabel: UILabel!
    
    @IBOutlet var procentLabel: UILabel!
    @IBOutlet var arrowImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(unitsWeights), name: NSNotification.Name(rawValue: "unit changed"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NSNotification.Name(rawValue: "height changed"), object: nil)
        
        updateData()
        
        UserSettings.shared.isOnboardingCompleted = true
    }
    
    func didLogWeight() {
        updateData()
    }
    
    @objc func updateData() {
        let lastWeight = StorageManager.getLastWeight()
        self.weight = lastWeight?.weight
        self.date = lastWeight?.date
        UserSettings.shared.oldWeight = StorageManager.getPenultimateWeight()?.weight
        
        if let height = UserSettings.shared.height {
            self.height = Double(height)
        } else {
            self.height = nil
        }
        
        if height != nil, weight != nil {
            bmi = self.weight! / pow((self.height! / 100), 2.0)
        } else {
            bmi = nil
        }
        bmiMessageLabel.text = bmiClassification
        
        if let oldWeight = UserSettings.shared.oldWeight, let weight = weight {
            if oldWeight > weight {
                procentLabel.text = String(format: "%.1f %%", 100 - (100 * oldWeight / weight))
                arrowImage.image = UIImage(systemName: "arrow.down")
            } else {
                arrowImage.image = UIImage(systemName: "arrow.up")
                procentLabel.text = String(format: "%.1f %%", 100 - (100 * oldWeight / weight))
            }
        } else {
            procentLabel.text = "-- %"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.mainViewController.change.identifier {
            let vc =  segue.destination as! DataInputViewController
            vc.delegate = self
        }
    }
    
    @objc func unitsWeights() {
        if UserSettings.shared.unit == .pounds {
            poundsFormat()
        } else if UserSettings.shared.unit == .kilograms {
            kilogramsFormat()
        }
    }
    
    func poundsFormat() {
        if let weight = weight {
            weightLabel.text = String(format: "%.1f lb", weight * PDS_IN_KG )
        } else {
            weightLabel.text = "--"
        }
    }
    
    func kilogramsFormat() {
        weightLabel.text = String(format: "%.1f kg", weight ?? "--")
    }
    
}
