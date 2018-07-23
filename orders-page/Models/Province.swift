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
    
    var title: String
    var orderArray: [Order]
    let backgroundColor: UIColor = UIColor.gray
    var isExpandable: Bool = true
    
    init(){
        self.title = ""
        self.orderArray = []
    }
}
