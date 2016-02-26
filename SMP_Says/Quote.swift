//
//  Quote.swift
//  SMP_Says
//
//  Created by Monte's Pro 13" on 2/5/16.
//  Copyright © 2016 Stuff My Professor Says. All rights reserved.
//

import UIKit

class Quote: NSObject {
    
    let id: NSNumber?
    let quotation: String?
    let school: String?
    let professor: String?
    let subject: String?
    let leftvotes: NSNumber?
    let rightvotes: NSNumber?
    let datetime: NSDate?
    let flag: Bool?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? NSNumber
        quotation = dictionary["quotation"] as? String
        school = dictionary["school"] as? String
        professor = dictionary["professor"] as? String
        subject = dictionary["subject"] as? String
        leftvotes = dictionary["leftvotes"] as? NSNumber
        rightvotes = dictionary["rightvotes"] as? NSNumber
        datetime = dictionary["datetime"] as? NSDate
        flag = dictionary["flag"] as? Bool
    }
    
    class func quotes(array array: [NSDictionary]) -> [Quote] {
        var quotes = [Quote]()
        for dictionary in array {
            let quote = Quote(dictionary: dictionary)
            quotes.append(quote)
        }
        return quotes
    }

}
