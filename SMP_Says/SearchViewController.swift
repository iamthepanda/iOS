//
//  SearchViewController.swift
//  SMP_Says
//
//  Created by Evan Edge on 6/23/16.
//  Copyright © 2016 Stuff My Professor Says. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchSelector: UISegmentedControl!
    @IBOutlet weak var searchResultsTable: UITableView!
    @IBOutlet weak var searchResultField: UITableView!
    
    var searchResults : [NSDictionary]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        
        
         //create the search bar programatically
//        searchBar = UISearchBar()
        searchBar.delegate = self
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Enter search term"
//        searchBar.tintColor = UIColor.blackColor()
        searchBar.becomeFirstResponder()
        searchBar.subviews[0].subviews.flatMap(){ $0 as? UITextField }.first?.tintColor = UIColor.blackColor()
        //navigationItem.titleView = searchBar
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuoteCell", forIndexPath: indexPath) as! QuoteCell
        
        //cell.quote = Quote(dictionary: self.quotes[indexPath.row])
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}