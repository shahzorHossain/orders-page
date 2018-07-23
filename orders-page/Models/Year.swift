//
//  Year.swift
//  orders-page
//
//  Created by Shahzor Khaled Hossain on 2018-07-23.
//  Copyright © 2018 Shahzor Khaled Hossain. All rights reserved.
//

import Foundation

class Year {
    var order: [Order]
    var year: String?
    
    init(){
        self.order = []
        self.year = nil
    }
    init(Order _order: Order,Year _year: String){
        self.order = []
        self.order.append(_order)
        self.year = _year
    }
}
