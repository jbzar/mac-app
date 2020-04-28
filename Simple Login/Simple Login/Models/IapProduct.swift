//
//  IapProduct.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 28/04/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Foundation

enum IapProduct {
    case monthly, yearly
    
    var productId: String {
        switch self {
        case .monthly: return "io.simplelogin.macapp.subscription.premium.monthly"
        case .yearly: return "io.simplelogin.macapp.subscription.premium.yearly"
        }
    }
}
