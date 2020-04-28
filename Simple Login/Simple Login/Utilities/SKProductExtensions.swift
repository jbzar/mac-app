//
//  SKProductExtensions.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 28/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct {
    /// - returns: The cost of the product formatted in the local currency.
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
}
