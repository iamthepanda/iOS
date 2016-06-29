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

class AddQuoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var quoteView: UITextView!
    @IBOutlet weak var schoolField: TextFieldAutoComplete!
    @IBOutlet weak var professorField: TextFieldAutoComplete!
    @IBOutlet weak var subjectField: TextFieldAutoComplete!
    
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.quoteView.becomeFirstResponder()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        assignFieldDataSource("http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/search/subjects", field: 3, attempts: 0)
        assignFieldDataSource("http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/search/schools", field: 1, attempts: 0)
        
        let logo = UIImage(named: "SMPSLogo.png")
        let imageFrame = CGRect(x: -120, y: 0, width: 240, height: 43)
        let titleImageView = UIImageView(frame: imageFrame)
        let titleView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 43))
        titleView.addSubview(titleImageView)
        titleView.contentMode = .ScaleAspectFit
        titleImageView.image = logo
        navigationItem.titleView = titleView
        
        if let schoolFieldContents = defaults.stringForKey("schoolFieldContents") {
            schoolField.text = schoolFieldContents
        }
        
        quoteView.delegate = self
        schoolField.delegate = self
        professorField.delegate = self
        subjectField.delegate = self
        
        quoteView.tag = 0
        schoolField.tag = 1
        professorField.tag = 2
        subjectField.tag = 3
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddQuoteViewController.keyboardWillShowOrHide(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddQuoteViewController.keyboardWillShowOrHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        //schoolField.addTarget(self, action: #selector(AddQuoteViewController.assignSchoolDataSource), forControlEvents: UIControlEvents.EditingChanged)

    
        
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
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(schoolField.text, forKey: "schoolFieldContents")
        
        addQuote(school, quoteText: quote, subjectText: subject, professorText: professor)
        
        let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("TableViewController") as? TableViewController
        let navigationController = UINavigationController(rootViewController: nextView!)
        self.presentViewController(navigationController, animated: true, completion: nil)
    
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
        if (textField.text!.characters.count > 50) {
            textField.deleteBackward()
        }
    }
    
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            let nextTag=textView.tag+1;
            // Try to find next responder
            let nextResponder=textView.superview?.viewWithTag(nextTag) as UIResponder!
            
            if (nextResponder != nil){
                // Found next responder, so set it.
                nextResponder?.becomeFirstResponder()
            }
            else
            {
                // Not found, so remove keyboard
                textView.resignFirstResponder()
            }
            return false
        }
        else {
            let maxtext: Int = 150
            return textView.text.characters.count + (text.characters.count - range.length) <= maxtext
        }
        
    }
    
    func assignFieldDataSource (url : String, field: Int, attempts: Int){
        
        var tries = 0
        var list: Array<String> = []
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                switch response.result {
                case .Success(let JSON):
                    
                    //let JSON =  response.result.value as! [NSDictionary] //TODO: protect against unexpected nil- 'if let, else {protection statement}
                    let response = JSON as! [NSDictionary]
                    
                    //print(JSON)
                    
                    for object in response {
                        list.append(object.objectForKey("name") as! String)
                        }
                    print(list[0])
                    if field == 1 {
                        self.schoolField.assignDataSource(list)
                    }
                    else if field == 2 {
                        self.professorField.assignDataSource(list)
                    }
                    else {
                        self.subjectField.assignDataSource(list)
                    }
                    
                
                    
                case .Failure( _):
                    
                    tries += 1
                    
                    if (tries < 5) {
                        self.assignFieldDataSource(url, field: field, attempts: tries)
                    }
                    
                }
                
        }
        
    }
    
    func keyboardWillShowOrHide(notification: NSNotification) {
        
        // Pull a bunch of info out of the notification
        if let scrollView = scrollView, userInfo = notification.userInfo, endValue = userInfo[UIKeyboardFrameEndUserInfoKey], durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convertRect(endValue.CGRectValue, fromView: view.window)
            
            // Find out how much the keyboard overlaps the scroll view
            // We can do this because our scroll view's frame is already in our view's coordinate system
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset to avoid the keyboard
            // Don't forget the scroll indicator too!
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
            
                    
            let duration = durationValue.doubleValue
            UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTag=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            //self.view.endEditing(true)
            textField.resignFirstResponder()
            let bottomOffset: CGPoint = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height + 144)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
        return false // We do not want UITextField to insert line-breaks.
    }

//currently the schoolField data source is assigned during viewDidLoad.
//This method is quicker but the timing doesn't work correctly with a user who types at a normal speed.
    
//    @IBAction func assignSchoolDataSource() {
//        let range = schoolField.textRangeFromPosition(schoolField.beginningOfDocument, toPosition: (schoolField.selectedTextRange?.start)!)
//        let string: String = schoolField.textInRange(range!)!
//        if string.characters.count == 1 {
//            let url = "http://www.smpsays-api.xyz/RUEf2i15kex8nXhmJxCW2ozA5SNIyfLn/search/schools?name=\(string)"
//            assignFieldDataSource(url, field: 1, attempts: 0)
//        }
//    }
}
