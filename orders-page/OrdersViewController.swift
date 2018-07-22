//
//  OrdersViewController.swift
//  orders-page
//
//  Created by Shahzor Khaled Hossain on 2018-07-20.
//  Copyright © 2018 Shahzor Khaled Hossain. All rights reserved.
//

import UIKit

class OrdersViewController: UITableViewController {
    
    //initial variables
    let titles = Titles()
    let cellId = "cellId"
   
    
    var ordersArray = [
        Province(title: "Alaska" , orders:["Light Bulb", "Mattress", "Glowing Lamp", "Phone", "Book"]),
        Province(title: "Ontario",orders: ["Fridge", "Bed", "Fry Pan"]),
        Province(title: "British Columbia", orders: ["Spoons", "Napkins"])
    ]
    
    //making the animations for showIndex button
    
    @objc func handleShowIndexPath() {

        var indexPathArray: [IndexPath] = []
        
        for section in ordersArray.indices{
            for row in ordersArray[section].orderArray.indices{
                let indexPath = IndexPath(row: row, section: section)
                indexPathArray.append(indexPath)
            }
        }
        
        
        tableView.reloadRows(at: indexPathArray, with: .left)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up the header in the navigation bar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show By Year", style: .plain, target: self, action: #selector(handleShowIndexPath))
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

        let button = UIButton(type: .system)
        button.setTitle(ordersArray[section].title, for: .normal)
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        return button
        
        
//        let label = UILabel()
//        label.text = alaska.title
//        label.backgroundColor = alaska.backgroundColor
//        return label
    }
    
    //handling the close button for each header
    @objc func handleExpandClose(button: UIButton) {
        
        var indexPathArray:[IndexPath] = []
        let section = button.tag
        
        for row in ordersArray[section].orderArray.indices {
            let indexPath = IndexPath(row: row, section: section)
            
            indexPathArray.append(indexPath)
        }
        
        let isExpanded = ordersArray[section].isExpandable
        ordersArray[section].isExpandable = !isExpanded
        
        if isExpanded {
            tableView.deleteRows(at: indexPathArray, with: .fade)
        }
        else {
            tableView.insertRows(at: indexPathArray, with: .fade)
            
        }
    }
    //for the divider height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    //For the tableView rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
         this is how we vary the number of elements in each section
         */
        
        
        if !ordersArray[section].isExpandable {
            return 0
        }
        
        return ordersArray[section].orderArray.count
        
        
        
    }
    
    //labelling each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
//        let order = indexPath.section == 0 ? orders[indexPath.row] : cNames[indexPath.row]
        
        let order = (ordersArray[indexPath.section].orderArray)[indexPath.row]
        
        cell.textLabel?.text = "\(order) Section: \(indexPath.section) Row: \(indexPath.row) "
        return cell
    }


}


















