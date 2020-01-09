//
//  SettingTableViewController.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/4/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit
import StoreKit
import HealthKit


class SettingTableViewController: UITableViewController {
    
    let notificationService = NotificationService()
    var settings: [Settings] = []
    let healthKitSetupAssistant = HealthKitSetupAssistant.assistent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onViewReady()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingCell.identifier, for: indexPath) as! SettingTableViewCell
        let setting = settings[indexPath.row]
        cell.settingLabel.text = setting.name
        cell.segmentedControl.isHidden = true
        cell.heightLabel.isHidden = true
        
        switch setting {
        case .accessToHealth(let state):
            cell.waitingIndicator.isHidden = true
            cell.switcher.isHidden = false
            cell.switcher.isOn = (state == .enabled)
            cell.switcher.addTarget(nil, action: #selector(authorize(sender:)), for: .valueChanged)
            
        case .units:
            cell.waitingIndicator.isHidden = true
            
            cell.switcher.isHidden = true
            
            cell.segmentedControl.isHidden = false
            cell.segmentedControl.addTarget(self, action: #selector(selectedValue), for: .valueChanged)
            
            if UserSettings.shared.unit == .kilograms {
                cell.segmentedControl.selectedSegmentIndex = 1
            } else {
                cell.segmentedControl.selectedSegmentIndex = 0
            }
            
        case .notification(let state):
            switch state {
            case .waiting:
                cell.switcher.isHidden = true
                cell.switcher.isOn = false
                
                cell.waitingIndicator.isHidden = false
                cell.waitingIndicator.startAnimating()
            default:
                cell.waitingIndicator.isHidden = true
                cell.waitingIndicator.stopAnimating()
                
                cell.switcher.isHidden = false
                cell.switcher.isOn = (state == .enabled)
                cell.switcher.addTarget(nil, action: #selector(pushNotificationDidChangeState(sender:)), for: .valueChanged)
            }
            
        case .height:
            cell.heightLabel.isHidden = false
            cell.waitingIndicator.isHidden = true
            cell.switcher.isHidden = true
            if let height = UserSettings.shared.height {
                cell.heightLabel.text = "\(String(describing: height)) cm"
            }
        default:
            cell.segmentedControl.isHidden = true
            cell.selectionStyle = .default
            cell.switcher.isHidden = true
            cell.switcher.isOn = false
            cell.waitingIndicator.isHidden = true
            cell.waitingIndicator.stopAnimating()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch settings[indexPath.row] {
        case .rateUs:
            SKStoreReviewController.requestReview()
        case .notification:
            break
        case .tellAFriend:
            let urlArray = ["https://AppUrl"]
            let shareController = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
            return present(shareController, animated: true)
        case .privacyPolicy:
            if let url = URL(string: "https://vadimlabun.wordpress.com/privacy/") {
                UIApplication.shared.open(url)
            }
        case .units:
            break
        case .height:
            alert()
        case .accessToHealth:
            break
        }
    }
    
    
    @objc func selectedValue(target: UISegmentedControl) {
        switch target.selectedSegmentIndex {
        case 0:
            UserSettings.shared.unit = .pounds
        case 1:
            UserSettings.shared.unit = .kilograms
        default:
            break
        }
    }
    
    @IBAction func closeSettings(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
//    MARK:- Push Notification
    
    @objc func pushNotificationDidChangeState(sender: UISwitch) {
        notificationService.enableNotification(sender.isOn) {
            self.reloadItems()
        }
    }
    
    func getItems(authorizationStatus: NotificationAuthorizationStatus?) -> [Settings] {
        
        
        var notificationState: Settings.State = .waiting
        let healthState: HealthKitStoreState =  HealthKitSetupAssistant.assistent.determineState()
        
        if let status = authorizationStatus {
            if status == .enabled {
                notificationState = .enabled
            } else {
                notificationState = .disabled
            }
        }
        
        return [
            .units,
            .height,
            .notification(state: notificationState),
            .accessToHealth(state: healthState),
            .privacyPolicy,
            .rateUs,
            .tellAFriend,
        ]
    }
    
    func reloadItems() {
        notificationService.getAuthorizationStatus { [weak self] (status) in
            guard let `self` = self else { return }
            let items = self.getItems(authorizationStatus: status)
            self.reload(items: items)
        }
    }
    
    func reload(items: [Settings]) {
        self.settings = items
        tableView.reloadData()
    }
    
    func onViewReady() {
        let items = self.getItems(authorizationStatus: nil)
        reload(items: items)
        self.reloadItems()
    }
    
//    MARK:- HealthKit
    
    func alert() {
        let ac = UIAlertController(title: R.string.locolazible.settingsItemAddHeight(),
                                   message: R.string.locolazible.settingsItemAddNewHeight(),
                                   preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: R.string.locolazible.settingsItemOk(), style: .default) { action in
            guard let text = ac.textFields?[0].text, text.count > 0 else { return }
           
            UserSettings.shared.height = Int(text)
            
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: R.string.locolazible.settingsItemCancel(), style: .default, handler: nil)
        ac.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = R.string.locolazible.settingsItemEnterYourHeight()
        }
        
        ac.addAction(okAction)
        ac.addAction(cancel)
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc func authorize(sender: UISwitch) {
        authorizeHealthKit(sender.isOn)
    }
    
    @objc func authorizeHealthKit(_ isEnabled: Bool) {
        healthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
        }
    }
    
}
