//
//  ViewController.swift
//  SMP_Says
//
//  Created by Monte's Pro 13" on 2/3/16.
//  Copyright © 2016 Stuff My Professor Says. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var quotesTableView: UITableView!
    
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var searchBarDisplay : Bool! = false
    
    var quotes : [NSDictionary]! = []
    
    var searchBar : UISearchBar!
    var searchResults : [NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        
        
        //set tableviewcell row height
        quotesTableView.rowHeight = UITableViewAutomaticDimension
        quotesTableView.estimatedRowHeight = 120
        
        // create the search bar programatically
        self.searchBar = UISearchBar()
        searchBar.delegate = self
        self.searchBar.sizeToFit()
        searchBar.placeholder = "Enter search term"
        
        if (searchBarDisplay == false) {
            navigationItem.title = "Stuff My Professor Says"
        }
        
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 28/255, green: 129/255, blue: 183/255, alpha: 1)
        
        let url = "http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/search/quotes"
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                
                let JSON =  response.result.value as! [NSDictionary]
                
                for quote in JSON {
                    
                    self.quotes.append(quote)
                }
                
                self.searchResults = self.quotes
                self.quotesTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuoteCell", forIndexPath: indexPath) as! QuoteCell
        
        cell.quote = Quote(dictionary: self.quotes[indexPath.row])
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if (searchBarDisplay == false) {
         searchBar.resignFirstResponder()
        }
//        else {
//            searchBarDisplay = false
//            navigationItem.title = "Stuff My Professor Says"
//        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        navigationItem.titleView = nil
        
        navigationItem.title = "Stuff My Professor Says"
    }
    
    @IBAction func searchBarButtonClicked(sender: AnyObject) {
        //add the search bar to the navigation bar and customize the nav bar
        navigationItem.titleView = searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

