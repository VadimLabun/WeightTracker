//
//  HistoryTableViewController.swift
//  Weight-tracker
//
//  Created by Vadim Labun on 11/2/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryTableViewController: UITableViewController {
    
    var weightsArray: Results<WeightModel>!
    
    let dateFormater: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d-MMM-yyyy HH:mm"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightsArray = StorageManager.getAllWeights()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weightsArray.count != 0 {
            return weightsArray.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.historyCell.identifier, for: indexPath)
        let weight = weightsArray[indexPath.row]
        cell.detailTextLabel?.text = String(format: "%.1f kg", weight.weight)
        cell.textLabel?.text = "\(dateFormater.string(from: weight.date))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delet") { (_, _, handler) in
            let weight = self.weightsArray[indexPath.row]
            StorageManager.deleteObject(weight)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            handler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
