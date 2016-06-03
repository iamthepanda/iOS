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
    
    @IBOutlet weak var quoteOrganizationSwitch: UISegmentedControl!
    
    @IBOutlet weak var quotesTableView: UITableView!
    
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    //var searchBarDisplay : Bool! = false
    
    var quotes : [NSDictionary]! = []
    
    //var searchBar : UISearchBar!
    var searchResults : [NSDictionary]!
    
    var tries: Int = 0 //API call set to try 5 times and then quit. This keeps track of how many times it has been tried
    var quotesPerPage: Int = 15 //how many quotes will be loaded at one time
    var pages: Int = 0 //incremented as we scroll for use in API call
    var quotePage: Int = 0 //0 for new, 1 for popular
    var didSwitchOrganization: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        
        quoteOrganizationSwitch.addTarget(self, action: #selector(TableViewController.quoteOrganizationChanged(_:)), forControlEvents: .ValueChanged);
        
        
        //set tableviewcell row height
        quotesTableView.rowHeight = UITableViewAutomaticDimension
        quotesTableView.estimatedRowHeight = 120
        
        // create the search bar programatically
        //self.searchBar = UISearchBar()
        //searchBar.delegate = self
        //self.searchBar.sizeToFit()
        //searchBar.placeholder = "Enter search term"
        
        //if (searchBarDisplay == false) {
        let logo = UIImage(named: "SMPSLogo.png")
        let imageFrame = CGRect(x: -120, y: 0, width: 240, height: 43)
        let titleImageView = UIImageView(frame: imageFrame)
        let titleView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 43))
        titleView.addSubview(titleImageView)
        titleView.contentMode = .ScaleAspectFit
        titleImageView.image = logo
        navigationItem.titleView = titleView
        
        //}
        
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 28/255, green: 129/255, blue: 183/255, alpha: 1)
        
        let url = "http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/search/quotes?amount=15"
        
        didSwitchOrganization = true
        
        fillTableView(url)
        
    }
    
    
    func quoteOrganizationChanged(sender: UISegmentedControl) {
        
        var url: String = ""
        didSwitchOrganization = true
        pages = 0
        
        if quoteOrganizationSwitch.selectedSegmentIndex == 0 {
            self.quotePage = 0
            url = "http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/search/quotes?amount=15"
        }
        else {
            self.quotePage = 1
            url = "http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/search/quotes?popularity=desc&amount=15"
        }
        
        fillTableView(url)
        
        quotesTableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0),
                                             animated: false,
                                             scrollPosition: UITableViewScrollPosition.Bottom)
        
        
    }
    
    func fillTableView (url : String) {
        
        self.tries = 0
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                switch response.result {
                case .Success( _):
                    
                    let JSON =  response.result.value as! [NSDictionary] //TODO: protect against unexpected nil- 'if let, else {protection statement}
                    
                    if self.didSwitchOrganization {
                        self.quotes = []
                    }
                    
                    for quote in JSON {
                        
                        self.quotes.append(quote)
                    }
                    
                    self.searchResults = self.quotes
                    self.quotesTableView.reloadData()
                    
                case .Failure( _):
                    if (self.tries < 5) {
                        self.fillTableView(url)
                    }
                    self.tries += 1
                }
                
        }

        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let index = (self.pages + 1) * self.quotesPerPage - 3
        
        let indexForRefresh = NSIndexPath(forRow: index, inSection: 0)
        
        if (indexPath == indexForRefresh) {
            var url: String
            self.pages += 1
            
            if self.quotePage == 0 {
                url = "http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/search/quotes?amount=15&pages=" + String(self.pages)
            }
            else {
                url = "http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/search/quotes?popularity=desc&amount=15&pages=" + String(self.pages)
            }
            self.didSwitchOrganization = false
            
            fillTableView(url)
            
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
    
    //func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    //    if (searchBarDisplay == false) {
    //     searchBar.resignFirstResponder()
    //    }
//        else {
//            searchBarDisplay = false
//            navigationItem.title = "Stuff My Professor Says"
//        }
    //}
    
    //func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    //    searchBar.showsCancelButton = true
    //}
    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//        navigationItem.titleView = nil
//        
//        let logo = UIImage(named: "SMPSLogo.png")
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 240, height: 43))
//        imageView.contentMode = .ScaleAspectFit
//        imageView.image = logo
//        navigationItem.titleView = imageView
//    }
//    
//    @IBAction func searchBarButtonClicked(sender: AnyObject) {
//        //add the search bar to the navigation bar and customize the nav bar
//        navigationItem.titleView = searchBar
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    
}

