//
//  QuoteCell.swift
//  SMP_Says
//
//  Created by Monte's Pro 13" on 2/5/16.
//  Copyright © 2016 Stuff My Professor Says. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {
    
    @IBOutlet weak var quotationLabel: UILabel!
    
    @IBOutlet weak var schoolLabel: UILabel!
    
    @IBOutlet weak var upVoteButton: UIButton!
    
    @IBOutlet weak var downVoteButton: UIButton!
    
    @IBOutlet weak var voteCountLabel: UILabel!

    @IBOutlet weak var subjectLabel: UILabel!
    
    var upvoted = false
    var downvoted = false
    var quote : Quote! {
        didSet {
            quotationLabel.text = quote.quotation
            schoolLabel.text = quote.school
           // professorLabel.text = quote.professor
            subjectLabel.text = quote.subject
            voteCountLabel.text = quote.rightvotes?.stringValue
            
            
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
        if (upvoted == true) {
            upVoteButton.setImage(UIImage(named: "up"), forState: UIControlState.Normal)
            upvoted = false
            //TODO: api call for downvote
        } else if (downvoted == true) {
            upVoteButton.setImage(UIImage(named: "up-red"), forState: UIControlState.Normal)
            downVoteButton.setImage(UIImage(named: "down"), forState: UIControlState.Normal)
            upvoted = true
            downvoted = false
            //TODO: api call for upvote 2 points (to be implemented on API end ASAP)
        } else if (upvoted != true) {
            upVoteButton.setImage(UIImage(named: "up-red"), forState: UIControlState.Normal)
            upvoted = true
            //TODO: api call for upvote
        }
        
    }
    
    @IBAction func downVoteButtonClicked(sender: AnyObject) {
        if (downvoted == true) {
            downVoteButton.setImage(UIImage(named: "down"), forState: UIControlState.Normal)
            downvoted = false
            //TODO: api call for downvote
        } else if (upvoted == true) {
            upVoteButton.setImage(UIImage(named: "up"), forState: UIControlState.Normal)
            downVoteButton.setImage(UIImage(named: "down-yellow"), forState: UIControlState.Normal)
            upvoted = false
            downvoted = true
            //TODO: api call for downvote 2 points (to be implemented on API end ASAP)
        } else if (downvoted != true){
            downVoteButton.setImage(UIImage(named: "down-yellow"), forState: UIControlState.Normal)
            downvoted = true
            //TODO: api call for downvote
        }
        
    }

}
