//
//  CurrenciesViewController.swift
//  CodeChallenge
//
//  Created by Pierluigi Galdi on 18/01/18.
//  Copyright © 2018 Pierluigi Galdi. All rights reserved.
//

import UIKit

class CurrenciesViewController: UIViewController {

    /// UIs
    @IBOutlet weak var mainTableView: UITableView!
    
    /// Data
    fileprivate var currenciesList: [String] = [] {
        didSet {
            self.mainTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set title
        self.title = "Currencies"
        
        /// Populate currenciesList
        for (key,_) in AppDelegate.currenciesList {
            self.currenciesList.append(key)
        }
        self.currenciesList.sort(by: { $1 > $0 })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currenciesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCurrencyCellIdentifier, for: indexPath)
        
        /// Get index item
        let currency = self.currenciesList[indexPath.row]
        
        cell.textLabel?.text = AppDelegate.currenciesList[currency]
        cell.detailTextLabel?.text = currency
        
        if currency == UserDefaults.standard.string(forKey: kCurrentSelectedCurrency) ?? "USD" {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /// Update UserDefaults
        UserDefaults.standard.set(self.currenciesList[indexPath.row], forKey: kCurrentSelectedCurrency)
        
        /// Reload table view
        tableView.reloadData()
    }
    
}
