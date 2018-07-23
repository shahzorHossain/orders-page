//
//  Customer.swift
//  orders-page
//
//  Created by Shahzor Khaled Hossain on 2018-07-23.
//  Copyright © 2018 Shahzor Khaled Hossain. All rights reserved.
//

import Foundation

class Customer {
    
    var shippingAddress: String
    var id: NSNumber?
    
    init() {
        self.id = nil
        self.shippingAddress = ""
        
    }
}
