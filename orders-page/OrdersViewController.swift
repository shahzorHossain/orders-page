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
    let titles = Titles() // a struct of headings
    let cellId = "cellId"
    var ordersArray : [Province] = [] //essentially a 2D array for provinces
    var yearsArray: [Year] = [] // same thing, since Year has an array of orders
    var yearFlag = true // to toggle between show by province - show by year

    // making the animations for displaying by year - by province button
    
    @objc func handleShowIndexPath() {

        yearFlag = !yearFlag
        
    //if it's show by year
        if yearFlag == false {
            navigationItem.title = titles.ByYear
            navigationItem.rightBarButtonItem?.title = "Show By Province"
            
        }
    //if it's show by province
        else {
            navigationItem.title = titles.ByProvince
            navigationItem.rightBarButtonItem?.title = "Show By Year"
            
        }
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populateArray() //this populates both the year array, and orders array using REST API
        
        //setting up the header in the navigation bar by default
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show By Year", style: .plain, target: self, action: #selector(handleShowIndexPath))
        navigationItem.title = titles.ByProvince
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    //populating the ordersArray and yearArray from API
    func populateArray(){
        
        Alamofire.request("https://shopicruit.myshopify.com/admin/orders.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6").responseJSON { response in
            
            
            if let data = response.result.value as? [String : Any] {
                if let json = data["orders"] as? [[String : Any]] {
                    
                    for orderDetails in json { //we get the main details in orderDetails
                        
                        let province: Province = Province()
                        let order: Order = Order()
                        let customer: Customer = Customer()
                        
                        if let shippingAddr = orderDetails["shipping_address"] as? NSDictionary{
                            if let orderProvince = shippingAddr["province"] as? String{
                                
                                //constructing the province, customer, and orders
                                province.title = orderProvince
                                customer.shippingAddress = orderProvince
                            }
                            
                        } else {
                            // there's a problem in the API where one of the orders doesn't have a shipping addr.
                            //as a result I assumed that the order is invalid and I just skip the order
                            continue
                        }
                        
                        //for customer information
                        if let customerData = orderDetails["customer"] as? NSDictionary{
                            if let id = customerData["id"] as? NSNumber{
                                customer.id = id
                            }
                        }
                        
                        //for finding the years, converting Date to String in extractDate()
                        if let id = orderDetails["id"] as? NSNumber, let date = orderDetails["created_at"] as! String?{
                            let year = self.extractDate(date: date)
                            
                            order.orderId = id
                            order.province = province.title
                            order.customer = customer
                            order.date = year
                        }
                        
                        self.handleDuplicateProvinceAndYear(newProvince: province, newOrder: order)
                        
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
    
    //this is where we find duplicates, or insert new entries into the arrays
    func handleDuplicateProvinceAndYear(newProvince: Province, newOrder: Order) {
        
        var duplicateYearFlag = true
        
        //for the yearArray
        for index in 0..<self.yearsArray.count {
            //if theres a duplicate, append to existing list
            if self.yearsArray[index].year == newOrder.date{
                
                self.yearsArray[index].order.append(newOrder)
                duplicateYearFlag = false
                break
            }
        }

        //for the orderArray
        for index in 0..<self.ordersArray.count {
            if self.ordersArray[index].title == newProvince.title {
                
                //add order id into the existing province
                self.ordersArray[index].orderArray.append(newOrder)
                return

            }
        }
        
        //if there's a new item, append to list
        if(duplicateYearFlag == true){
            self.yearsArray.append(Year(Order: newOrder, Year: newOrder.date!))
            
        }
        
        //same for the province list
        newProvince.orderArray.append(newOrder)
        self.ordersArray.append(newProvince)
        return



    }

    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        //if it's show by province
        if yearFlag == true {
            return ordersArray.count
            
        }
            //if it's show by year
        else {
            return yearsArray.count

        }
        
    }
    
    //divider between every section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let button = UIButton(type: .system)
        
        //if it's show by province
        if yearFlag == true {
            button.setTitle(ordersArray[section].title, for: .normal)
        
        }
        //if it's show by year
        else {
            button.setTitle(yearsArray[section].year, for: .normal)

        }
        
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        return button
        
    }
    
    //this creates the collapsing effect for each subheading
    @objc func handleExpandClose(button: UIButton) {
        
        var indexPathArray:[IndexPath] = []
        let section = button.tag
        
        
        if yearFlag == true { // show by Province
        
            for row in ordersArray[section].orderArray.indices {
                let indexPath = IndexPath(row: row, section: section)
                
                indexPathArray.append(indexPath)
            }
            
            let isExpanded = ordersArray[section].isExpandable
            
            //once collapsed, we change the isExpanded to false and vice versa
            ordersArray[section].isExpandable = !isExpanded
            
            if isExpanded {
                tableView.deleteRows(at: indexPathArray, with: .fade)
            }
            else {
                tableView.insertRows(at: indexPathArray, with: .fade)
                
            }
            
        }
        else {
            
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
        
        if yearFlag == true { // show by Province
        
            return ordersArray[section].orderArray.count
       }
        else { // show by year
            return yearsArray[section].order.count
        }
        
    }
    
    //labelling each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 15.0)
        var order: Order
        
        if yearFlag == true {// show by Province
            order = (ordersArray[indexPath.section].orderArray)[indexPath.row]
        
        }
        else { // show by Year
            order = yearsArray[indexPath.section].order[indexPath.row]
        }
        
        if let orderid = order.orderId as? Int64{
            if let customerid = order.customer?.id as? Int64{
                cell.textLabel?.text = "OrderID: \(orderid) | CustomerID: \(customerid)"
            }
        }
        return cell
    }


}


















