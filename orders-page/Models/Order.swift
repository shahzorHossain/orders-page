//
//  Order.swift
//  orders-page
//
//  Created by Shahzor Khaled Hossain on 2018-07-23.
//  Copyright © 2018 Shahzor Khaled Hossain. All rights reserved.
//

import Foundation

class Order {
    var province: String
    var orderId: NSNumber?
    var customer: Customer?
    var date: String?
    
    init() {
        self.province = ""
        self.orderId = nil
        self.customer = nil
        self.date = nil
    }
    
}
