//
//  CurrenciesConverter.swift
//  CodeChallenge
//
//  Created by Pierluigi Galdi on 18/01/18.
//  Copyright © 2018 Pierluigi Galdi. All rights reserved.
//

import Foundation

extension NSDecimalNumber {
    class var cents: NSDecimalNumber {
        return NSDecimalNumber(value: 100.0)
    }
}

class CurrenciesConverter {
    
    /// Get formatted price
    class func getFormattedPrice(price: Double) -> String {
        let currentSelectedCurrency = UserDefaults.standard.string(forKey: kCurrentSelectedCurrency) ?? "USD"
        var _price = price
        if currentSelectedCurrency != "USD" {
            let conversionRate = AppDelegate.currenciesRates["USD\(currentSelectedCurrency)"] ?? 0
            _price = (price * conversionRate)
        }
        let decimalNumber = NSDecimalNumber(value: _price)
        let divided = decimalNumber.dividing(by: .cents, withBehavior: nil)
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.roundingMode = .ceiling
        if let formattedString = formatter.string(from: divided) {
            return "\(currentSelectedCurrency) \(formattedString)"
        }
        return "\(currentSelectedCurrency) \(divided)"
    }
    
}
