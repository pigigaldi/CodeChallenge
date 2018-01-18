//
//  ViewController.swift
//  CodeChallenge
//
//  Created by Pierluigi Galdi on 18/01/18.
//  Copyright © 2018 Pierluigi Galdi. All rights reserved.
//

import UIKit
import Disk
import SwiftyJSON

class ExperienceViewController: UIViewController {

    /// UIs
    @IBOutlet weak var bigActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var changeCurrencyButton: UIBarButtonItem!
    
    /// Data
    fileprivate var experiences: [Experience] = [] {
        didSet {
            
            /// Stop big activity indicator
            self.bigActivityIndicatorView.stopAnimating()
            self.reloadButton.isEnabled = true
            
            /// Check if experiences array is not empty
            if !self.experiences.isEmpty {
                
                /// Table view is visible
                self.mainTableView.reloadData()
                self.mainTableView.isHidden = false
                
            }else {
                
                // TODO: Inform user about this
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /// Set controller's title
        self.title = "Experiences"
        
        /// Hide bigActivityIndicator when stopped
        self.bigActivityIndicatorView.hidesWhenStopped = true
        
        /// mainTableView cell with dynamic height
        self.mainTableView.rowHeight = UITableViewAutomaticDimension
        self.mainTableView.estimatedRowHeight = 110
        
        /// Get currencies data
        self.fetchCurrenciesList()
        self.fetchCurrenciesRates()
        
        /// Try getting data from caches
        self.fetchExperiencesFromDisk()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Change button title to reflect current selected currency
        self.changeCurrencyButton.title = UserDefaults.standard.string(forKey: kCurrentSelectedCurrency) ?? "USD"
        self.mainTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// Fetch experiences from disk
    fileprivate func fetchExperiencesFromDisk() {
        
        /// Table view is initially hidden
        self.mainTableView.isHidden = true
        self.bigActivityIndicatorView.startAnimating()
        self.reloadButton.isEnabled = false
        
        do {
            let data = try Disk.retrieve(experienceFileName, from: .documents, as: ExperienceArray.self)
            self.experiences = data.experiences
        } catch {
            print("Can't get experience from caches. Error: \(error.localizedDescription)")
            
            /// Fetch experiences from network
            self.fetchExperiencesFromNetwork()
            
        }
        
    }
    
    /// Reload
    @IBAction func reloadDataFromNetwork() {
        
        /// Disable reload button
        self.reloadButton.isEnabled = false
        self.mainTableView.isHidden = true
        self.bigActivityIndicatorView.startAnimating()
        
        /// Clear the cache
        try? Disk.clear(.documents)
        
        /// Re-fetch data from network
        self.fetchCurrenciesList()
        self.fetchCurrenciesRates()
        self.fetchExperiencesFromNetwork()
        
    }
    
    /// Fetch experiences from network
    fileprivate func fetchExperiencesFromNetwork() {
        
        /// Show network activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        /// Get
        Networking.fetchExperiences(completion: { success in
            DispatchQueue.main.async {
                
                defer {
                    /// Hide network activity indicator
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                if !success {
                    print("Can't get experiences from network.")
                    self.experiences = []
                    return
                }
                
                /// Fetch experiences from disk
                self.fetchExperiencesFromDisk()
                
            }
        })
        
    }
    
}

extension ExperienceViewController {
    
    fileprivate func fetchCurrenciesList() {
        do {
            let jsonData = try Disk.retrieve(currenciesFileName, from: .documents, as: Data.self)
            
            /// Convert to JSON object
            if let jsonObj = try? JSON(data: jsonData) {
                if let currenciesDict = jsonObj.dictionaryValue["currencies"]?.dictionaryObject as? [String: String] {
                    AppDelegate.currenciesList = currenciesDict
                }
            }
            
        }catch {
            print("Can't retrieve currencies from local. Ask network for this. Error: \(error.localizedDescription)")
            Networking.fetchCurrenciesList(completion: { success in
                DispatchQueue.main.async {
                    if success {
                        self.fetchCurrenciesList()
                    }
                }
            })
        }
    }
    
    fileprivate func fetchCurrenciesRates() {
        self.changeCurrencyButton.isEnabled = false
        do {
            let jsonData = try Disk.retrieve(ratesFileName, from: .documents, as: Data.self)
            /// Convert to JSON object
            if let jsonObj = try? JSON(data: jsonData) {
                if let ratesDict = jsonObj.dictionaryValue["quotes"]?.dictionaryObject as? [String: Double] {
                    AppDelegate.currenciesRates = ratesDict
                    self.changeCurrencyButton.isEnabled = true
                }
            }
        }catch {
            print("Can't retrieve rates from local. Ask network for this. Error: \(error.localizedDescription)")
            Networking.fetchCurrenciesRates(completion: { success in
                DispatchQueue.main.async {
                    if success {
                        self.fetchCurrenciesRates()
                    }
                }
            })
        }
    }
    
}

extension ExperienceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.experiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kExperienceCellIdentifier, for: indexPath) as! ExperienceTableViewCell
        
        /// Get experience at index
        let experience = self.experiences[indexPath.row]
        
        /// Populate cell view
        cell.experienceItem = experience
        
        return cell
        
    }
    
}








