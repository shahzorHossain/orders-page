//
//  Province.swift
//  orders-page
//
//  Created by Shahzor Khaled Hossain on 2018-07-20.
//  Copyright © 2018 Shahzor Khaled Hossain. All rights reserved.
//

import Foundation
import UIKit


class Province {
    
    let title: String
    var orderArray: [String]
    let backgroundColor: UIColor = UIColor.gray
    
    init(name _title: String, order _orderId: String){
        self.title = _title
        self.orderArray = []
        self.orderArray.append(_orderId)
    }
}
