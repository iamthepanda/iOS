//
//  ViewController.swift
//  SMP_Says
//
//  Created by Monte's Pro 13" on 2/3/16.
//  Copyright © 2016 MonteThakkar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var quotesTableView: UITableView!
    
    
    
    var quotes : [NSDictionary]! = []
    
    //    var myArray : [CUSTOM_CLASS] = [CUSTOM_CLASS]()
    
//    var searchBar : UISearchBar!
    var searchResults : [NSDictionary]!
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        
        navigationItem.title = "Stuff My Professor Says"
        
        //set tableviewcell row height
        quotesTableView.rowHeight = UITableViewAutomaticDimension
        quotesTableView.estimatedRowHeight = 120
        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
//        self.searchBar = UISearchBar()
//        searchBar.delegate = self
//        self.searchBar.sizeToFit()
//        searchBar.placeholder = "Enter search term"
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 28/255, green: 129/255, blue: 183/255, alpha: 1)
        
        //add the search bar to the navigation bar and customize the nav bar
    //    navigationItem.titleView = searchBar
       // navigationController?.navigationBar.barTintColor = UIColor(red: 218/255, green: 56/255, blue: 40/255, alpha: 1)
        
        
        var url = "http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/search/quotes"
                Alamofire.request(.GET, url, parameters: nil)
                    .responseJSON { response in
        
                       // print(response.result.value)
                        let JSON =  response.result.value as! [NSDictionary]
                        
                        for quote in JSON {
                          //  print(quote)
                            self.quotes.append(quote)
                        }
                       
                      //  let quote = quotes(JSON)
                        
                      //  print(self.quotes[4])
                        
                        self.searchResults = self.quotes
                        self.quotesTableView.reloadData()
                        
                      //  print(self.quotes)
                        
        
//                        if let quotes: [Quote]? = response.result.value as! [Quote]!{
//                            self.quotes = quotes!
//                            print(quotes)
//                            self.searchResults = self.quotes
//                            self.quotesTableView.reloadData()
//                        }
                }
        
//        Alamofire.request(.GET, url).validate().responseJSON { response in
//            switch response.result {
//            case .Success:
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    print("JSON: \(json)")
//                    if let quote = json[0] as? Quote! {
//                      //  self.quotes = quotes!
//                        print(quote)
//                    //    self.searchResults = self.quotes
//                        self.quotesTableView.reloadData()
//                    }
//                }
//            case .Failure(let error):
//                print(error)
//            }
//        }
        
        
        
        
        //            self.businesses = businesses
        //
        //            self.searchResults = self.businesses
        //            self.businessTableView.reloadData()
        //
        //            for business in businesses {
        //                print(business.id!)
        //                print(business.name!)
        //                print(business.address!)
        //            }
        //
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuoteCell", forIndexPath: indexPath) as! QuoteCell
        
        cell.quote = Quote(dictionary: self.quotes[indexPath.row])
      //  print(cell.quote)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        //        self.searchResults = self.businesses
        //        self.businessTableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

