//
//  QuoteCell.swift
//  SMP_Says
//
//  Created by Monte's Pro 13" on 2/5/16.
//  Copyright © 2016 Stuff My Professor Says. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class QuoteCell: UITableViewCell {
    
    @IBOutlet weak var quotationLabel: UILabel!
    
    @IBOutlet weak var schoolLabel: UILabel!
    
    @IBOutlet weak var upVoteButton: UIButton!
    
    @IBOutlet weak var downVoteButton: UIButton!
    
    @IBOutlet weak var voteCountLabel: UILabel!

    @IBOutlet weak var subjectLabel: UILabel!
    
    var upvoted = false
    var downvoted = false
    var rightVotes : NSNumber = 0.0
    var leftVotes : NSNumber = 0.0
    var voteCount : Int = 0
    var id : Int = 0
    var postExistsInCoreData: Bool = false
    var fetchedPosts: NSArray = []
    
    var quote : Quote! {
        didSet {
            quotationLabel.text = quote.quotation
            schoolLabel.text = quote.school
           // professorLabel.text = quote.professor
            subjectLabel.text = quote.subject
            rightVotes = quote.rightvotes!
            leftVotes = quote.leftvotes!
            voteCount = rightVotes.integerValue - leftVotes.integerValue
            voteCountLabel.text = "\(voteCount)"
            id = (quote.id?.integerValue)!
            
            getCoreDataForQuote(id)

            print("\(quote.quotation)")
            print("\(quote.school)")
            print("\(quote.subject)")
            print("")
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
       // quotationLabel.preferredMaxLayoutWidth = quotationLabel.frame.size.width
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // quotationLabel.preferredMaxLayoutWidth = quotationLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func upVoteButtonClicked(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        if (upvoted == true) {
            upVoteButton.setImage(UIImage(named: "up"), forState: UIControlState.Normal)
            upvoted = false
            voteCount = voteCount - 1
            voteCountLabel.text = "\(voteCount)"
            vote("down", idNumber: id)
            moc.deleteObject(fetchedPosts[0] as! UserVotedPost)
        } else if (downvoted == true) {
            upVoteButton.setImage(UIImage(named: "up-red"), forState: UIControlState.Normal)
            downVoteButton.setImage(UIImage(named: "down"), forState: UIControlState.Normal)
            upvoted = true
            downvoted = false
            voteCount = voteCount + 2
            voteCountLabel.text = "\(voteCount)"
            //TODO: api call for upvote 2 points (to be implemented on API end ASAP)
            vote("up", idNumber: id)
            vote("up", idNumber: id)
            (fetchedPosts[0] as! UserVotedPost).upvote()
        } else if (upvoted != true) {
            upVoteButton.setImage(UIImage(named: "up-red"), forState: UIControlState.Normal)
            upvoted = true
            voteCount = voteCount + 1
            voteCountLabel.text = "\(voteCount)"
            vote("up", idNumber: id)
            let newPostData = UserVotedPost(id: id, vote: true, insertIntoManagedObjectContext: moc)
            fetchedPosts = [newPostData]
        }
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    @IBAction func downVoteButtonClicked(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        if (downvoted == true) {
            downVoteButton.setImage(UIImage(named: "down"), forState: UIControlState.Normal)
            downvoted = false
            voteCount = voteCount + 1
            voteCountLabel.text = "\(voteCount)"
            vote("up", idNumber: id)
            moc.deleteObject(fetchedPosts[0] as! UserVotedPost)
        } else if (upvoted == true) {
            upVoteButton.setImage(UIImage(named: "up"), forState: UIControlState.Normal)
            downVoteButton.setImage(UIImage(named: "down-yellow"), forState: UIControlState.Normal)
            upvoted = false
            downvoted = true
            voteCount = voteCount - 2
            voteCountLabel.text = "\(voteCount)"
            //TODO: api call for downvote 2 points (to be implemented on API end ASAP)
            vote("down", idNumber: id)
            vote("down", idNumber: id)
            (fetchedPosts[0] as! UserVotedPost).downvote()
        } else if (downvoted != true){
            downVoteButton.setImage(UIImage(named: "down-yellow"), forState: UIControlState.Normal)
            downvoted = true
            voteCount = voteCount - 1
            voteCountLabel.text = "\(voteCount)"
            vote("down", idNumber: id)
            let newPostData = UserVotedPost(id: id, vote: false, insertIntoManagedObjectContext: moc)
            fetchedPosts = [newPostData]
        }
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    func vote (direction : String, idNumber : Int) {
        let url = "http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/save/vote?id=\(idNumber)&direction=\(direction)"
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                print(response.response)
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    func getCoreDataForQuote (id: Int) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        let postFetch = NSFetchRequest(entityName: "Post")
        let predicate = NSPredicate(format: "id == %@", (id as NSNumber).stringValue)
        postFetch.predicate = predicate
        
        do {
            fetchedPosts = try moc.executeFetchRequest(postFetch) as! [UserVotedPost]
            
        }
        catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        if (fetchedPosts.count > 0 && (fetchedPosts[0] as! UserVotedPost).vote == false) {
            downvoted = true
            downVoteButton.setImage(UIImage(named: "down-yellow"), forState: UIControlState.Normal)
            postExistsInCoreData = true
        }
        else if (fetchedPosts.count > 0 && (fetchedPosts[0] as! UserVotedPost).vote == true) {
            upvoted = true
            upVoteButton.setImage(UIImage(named: "up-red"), forState: UIControlState.Normal)
            postExistsInCoreData = true
        }
        else {
            upvoted = false
            downvoted = false
            upVoteButton.setImage(UIImage(named: "up"), forState: UIControlState.Normal)
            downVoteButton.setImage(UIImage(named: "down"), forState: UIControlState.Normal)
        }
    }

}
