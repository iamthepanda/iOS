//
//  AddQuoteViewController.swift
//  SMP_Says
//
//  Created by Evan Edge on 2/25/16.
//  Copyright © 2016 Stuff My Professor Says. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddQuoteViewController: UIViewController {

    
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var quoteField: UITextField!
    @IBOutlet weak var subjectField: UITextField!
    @IBOutlet weak var professorField: UITextField!
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.quoteField.becomeFirstResponder()
    }
    
    
    @IBAction func onSubmitButtonClick(sender: AnyObject) {
        
        let school: String = schoolField.text!
        let quote: String = quoteField.text!
        let subject: String = subjectField.text!
        let professor: String = professorField.text!
        
        addQuote(school, quoteText: quote, subjectText: subject, professorText: professor)
    
    }
    
    func addQuote(schoolText: String, quoteText: String, subjectText: String, professorText: String) {
        
        let parameters = [
            "quotation": quoteText,
            "school": schoolText,
            "professor": professorText,
            "subject": subjectText
        ]

        let url = "http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/save/quote"
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .response { request, response, data, error in
                print(request)
                print(response)
                print(data)
                print(error)
            
        }

    }
    
    
}
