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

class AddQuoteViewController: UIViewController, UITextViewDelegate{

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var quoteView: UITextView!
    @IBOutlet weak var subjectField: UITextField!
    @IBOutlet weak var professorField: UITextField!
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.quoteView.becomeFirstResponder()
        
        let logo = UIImage(named: "SMPSLogo.png")
        let imageFrame = CGRect(x: -120, y: 0, width: 240, height: 43)
        let titleImageView = UIImageView(frame: imageFrame)
        let titleView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 43))
        titleView.addSubview(titleImageView)
        titleView.contentMode = .ScaleAspectFit
        titleImageView.image = logo
        navigationItem.titleView = titleView
        
        
        
        quoteView.delegate = self
        
        
    
        
        let borderColor : UIColor = UIColor( red: 204/255, green: 204/255, blue:204/255, alpha: 1.0 )
        
        quoteView.layer.borderColor = borderColor.CGColor;
        quoteView.layer.borderWidth = 0.5;
        quoteView.layer.cornerRadius = 6.0;
        
        submitButton.layer.cornerRadius = 6.0;
    }
    
    
    @IBAction func onSubmitButtonClick(sender: AnyObject) {
        
        let school: String = schoolField.text!
        let quote: String = quoteView.text!
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
    
    
    @IBAction func checkMaxLength(textField: UITextField!) {
        if (textField.text!.characters.count > 25) {
            textField.deleteBackward()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let maxtext: Int = 150

        return textView.text.characters.count + (text.characters.count - range.length) <= maxtext
        
    }
    
    
    
}
