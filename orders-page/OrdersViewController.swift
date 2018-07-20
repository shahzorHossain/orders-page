//
//  OrdersViewController.swift
//  orders-page
//
//  Created by Shahzor Khaled Hossain on 2018-07-20.
//  Copyright © 2018 Shahzor Khaled Hossain. All rights reserved.
//

import UIKit

//data structures
struct Titles {
    let Contacts = "Contacts"
    let TempVar = "Temp Var"
    let ByProvince = "By Province"
    let ByYear = "By Year"
}



class OrdersViewController: UITableViewController {
    
    //initial variables
    let titles = Titles()
    let cellId = "cellId"
    let alaska = Province(name: "Alaska", order: "565544dh332")
    
    let orders = ["Light Bulb", "Mattress", "Glowing Lamp", "Phone", "Book"]
    let cNames = ["Fridge", "Bed", "Fry Pan"]
    let dNames = ["Chris", "Tom"]
    
    let ordersArray = [
        ["Light Bulb", "Mattress", "Glowing Lamp", "Phone", "Book"],
        ["Fridge", "Bed", "Fry Pan"],
        ["Chris", "Tom"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up the header in the navigation bar
        navigationItem.title = titles.ByProvince
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ordersArray.count
    }
    
    //divider between every section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = alaska.title
        label.backgroundColor = alaska.backgroundColor
        return label
    }
    
    //For the tableView rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
         this is how we vary the number of elements in each section
         */
        
        //bad code
        
//        if section == 0 {
//        return orders.count
//        }
//        else{
//            return cNames.count
//        }
        
        
//      good code
        
        return ordersArray[section].count
        
        
        
    }
    
    //labelling each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
//        let order = indexPath.section == 0 ? orders[indexPath.row] : cNames[indexPath.row]
        
        let order = ordersArray[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = "\(order) Section: \(indexPath.section) Row: \(indexPath.row) "
        return cell
    }


}


















