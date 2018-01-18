//
//  Networking.swift
//  CodeChallenge
//
//  Created by Pierluigi Galdi on 18/01/18.
//  Copyright © 2018 Pierluigi Galdi. All rights reserved.
//

import Foundation
import Disk
import SwiftyJSON

class Networking {
    
    /// Core
    static let experienceUrl: String = "https://s3.amazonaws.com/staticfiles.popguide.me/code_challenge/exp/experiences.json"
    static let clBaseURL: String = "http://apilayer.net/api"
    static let clAPIKey: String = "5b4be7abd1e24e0ae28a46aa504302e2"
    
    /// Endpoints
    enum CLEndpoints: String {
        case live = "/live"
        case list = "/list"
    }
    
    /// Fetch experiences
    class func fetchExperiences(completion: @escaping (_ success: Bool) -> ()) {
        
        guard let url = URL(string: experienceUrl) else { completion(false); return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            /// Check for error and data
            guard error == nil else { completion(false); return }
            guard let data = data else { completion(false); return }
            
            /// Store data locally
            do {
             
                try Disk.save(data, to: .documents, as: experienceFileName)
                completion(true)
                
            }catch {
                
                print("Can't save experiences locally. Error: \(error.localizedDescription)")
                completion(false)
                
            }
            
        }
        
        task.resume()
        
    }
    
    /// Get live currencies rates
    class func fetchCurrenciesList(completion: @escaping (_ success: Bool) -> ()) {
        
        guard let url = URL(string: String(format: "%@%@?access_key=%@", clBaseURL, CLEndpoints.list.rawValue, clAPIKey)) else { completion(false); return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            /// Check for error and data
            guard error == nil else { completion(false); return }
            guard let data = data else { completion(false); return }
            
            /// Store data locally
            do {
                let json = try JSON(data: data)
                if json["success"].boolValue {
                    do {
                        try Disk.save(data, to: .documents, as: currenciesFileName)
                        completion(true)
                    }catch {
                        print("Can't save currencies locally. Error: \(error.localizedDescription)")
                        completion(false)
                    }
                }
            }catch {
                print("Currencieslayer returned an error. Error: \(error.localizedDescription)")
                completion(false)
            }
        
        }
        
        task.resume()
        
    }
    
    /// Get live currencies rates
    class func fetchCurrenciesRates(completion: @escaping (_ success: Bool) -> ()) {
        
        guard let url = URL(string: String(format: "%@%@?access_key=%@", clBaseURL, CLEndpoints.live.rawValue, clAPIKey)) else { completion(false); return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            /// Check for error and data
            guard error == nil else { completion(false); return }
            guard let data = data else { completion(false); return }
            
            /// Store data locally
            do {
                let json = try JSON(data: data)
                if json["success"].boolValue {
                    do {
                        try Disk.save(data, to: .documents, as: ratesFileName)
                        completion(true)
                    }catch {
                        print("Can't save rates locally. Error: \(error.localizedDescription)")
                        completion(false)
                    }
                }
            }catch {
                print("Currencieslayer returned an error. Error: \(error.localizedDescription)")
                completion(false)
            }
            
        }
        
        task.resume()
        
    }
    
}
