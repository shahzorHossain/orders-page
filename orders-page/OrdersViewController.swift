//
//  OrdersViewController.swift
//  orders-page
//
//  Created by Shahzor Khaled Hossain on 2018-07-20.
//  Copyright © 2018 Shahzor Khaled Hossain. All rights reserved.
//

import UIKit
import Alamofire

class OrdersViewController: UITableViewController {
    
    // initial variables
    let titles = Titles()
    let cellId = "cellId"
    var ordersArray : [Province] = []

    // making the animations for showIndex button
    
    @objc func handleShowIndexPath() {

        var indexPathArray: [IndexPath] = []
        
        for section in ordersArray.indices {
            for row in ordersArray[section].orderArray.indices {
                let indexPath = IndexPath(row: row, section: section)
                indexPathArray.append(indexPath)
            }
        }
        
        
        tableView.reloadRows(at: indexPathArray, with: .left)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populateArray()
        
        //setting up the header in the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show By Year", style: .plain, target: self, action: #selector(handleShowIndexPath))
        navigationItem.title = titles.ByProvince
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    //populating the ordersArray from API
    func populateArray(){
        
        Alamofire.request("https://shopicruit.myshopify.com/admin/orders.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6").responseJSON { response in
            
            
            if let data = response.result.value as? [String : Any] {
                if let json = data["orders"] as? [[String : Any]] {
                    
                    for orderDetails in json {
                        
                        let province: Province = Province()
                        let order: Order = Order()
                        let customer: Customer = Customer()
                        
                        if let shippingAddr = orderDetails["shipping_address"] as? NSDictionary{
                            if let orderProvince = shippingAddr["province"] as? String{
                                
                                
                                // checking for duplicate province in the ordersArray
                                province.title = orderProvince
                                customer.shippingAddress = orderProvince
                            }
                            
                        } else {
                            //skip to the next iteration
                            continue
                        }
                        
                        //for customer information
                        if let customerData = orderDetails["customer"] as? NSDictionary{
                            if let id = customerData["id"] as? NSNumber{
                                customer.id = id
                            }
                        }
                        
                        if let id = orderDetails["id"] as? NSNumber, let date = orderDetails["created_at"] as! String?{
                            let year = self.extractDate(date: date)
                            
                            order.orderId = id
                            order.province = province.title
                            order.customer = customer
                            order.date = year
                        }
                        
                        self.handleDuplicateProvince(newProvince: province, newOrder: order)
                        
                    }
                    
                    
                    
                }
            }
            //sorting the array alphabetically
            self.ordersArray = self.ordersArray.sorted { $0.title < $1.title }
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
            self.tableView.reloadData()
        }
        
        return
        
    }
    
    func extractDate(date _date: String) -> String{
        
        var year: String = ""
        let isoDate = _date
        let dateFormatter = ISO8601DateFormatter()
        if let formattedDate = dateFormatter.date(from: isoDate){
            let calendar = Calendar.current
            year = String(calendar.component(.year, from: formattedDate))
        }
        return year
    }
    
    func handleDuplicateProvince(newProvince: Province, newOrder: Order) {

        for index in 0..<self.ordersArray.count {
            if self.ordersArray[index].title == newProvince.title {
                //add order id into the existing province
                ordersArray[index].orderArray.append(newOrder)
                return

            }
        }
        newProvince.orderArray.append(newOrder)
        self.ordersArray.append(newProvince)
        return



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
        
        
        let order = (ordersArray[indexPath.section].orderArray)[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 15.0)
      
        
        if let orderid = order.orderId as? Int64{
            if let customerid = order.customer?.id as? Int64{
                cell.textLabel?.text = "OrderID: \(orderid) | CustomerID: \(customerid)"
            }
        }
        return cell
    }


}


















