//
//  UserVotedPost.swift
//  SMP_Says
//
//  Created by Evan Edge on 3/27/16.
//  Copyright © 2016 Stuff My Professor Says. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class UserVotedPost: NSManagedObject {
    
    @NSManaged var id: Int16
    @NSManaged var vote: Bool
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(id: Int, vote: Bool, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(id: Int, vote: Bool, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: context)
        self.init(id: id, vote: vote, entity: entity!, insertIntoManagedObjectContext: context)
        print(self.id)
        print(id)
        self.id = Int16(id)
        self.vote = vote
    }
    
    func upvote() {
        vote = true
    }
    
    func downvote() {
        vote = false
    }
    
}
