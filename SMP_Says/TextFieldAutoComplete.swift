//
//  TextFieldAutoComplete.swift
//  TextFieldAutoComplete
//
//  Created by Evan Edge on 6/6/16.
//  Copyright © 2016 eedge. All rights reserved.
//

import Foundation
import UIKit

class TextFieldAutoComplete: UITextField {
    var dataSource: Array<String> //will hold entire data source
    var dataList: Array<String> //will be sorted, trimmed, etc. as user types
    
    required init? (coder aDecoder: NSCoder) {
        dataSource = []
        dataList = []
        super.init(coder: aDecoder)!
        addTarget(self, action: #selector(TextFieldAutoComplete.autoComplete), forControlEvents: UIControlEvents.EditingChanged)
        addTarget(self, action: #selector(TextFieldAutoComplete.textToBlack), forControlEvents: UIControlEvents.EditingDidEnd)
        //addTarget(self, action: #selector(TextFieldAutoComplete.setCorrectColors), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func assignDataSource (data: Array<String>) {
        dataSource = data
        dataList = dataSource.sort()
    }
    
    @IBAction func autoComplete (){
        //first making sure everything left of cursor is normal text color and everything right is autocomplete color
        let cursorPositionTextRange = textRangeFromPosition(selectedTextRange!.start, toPosition: selectedTextRange!.start)
        
        let range: UITextRange? = textRangeFromPosition(beginningOfDocument, toPosition: selectedTextRange!.start)
        
        let autoCompleteRange = textRangeFromPosition(selectedTextRange!.start, toPosition: endOfDocument)
        
        attributedText = getColoredText(textInRange(range!)!, autoCompleteText: textInRange(autoCompleteRange!)!)
        
        selectedTextRange = cursorPositionTextRange
        
        var foundAutoCompleteMatch = false
        
        let inputText = textInRange(range!)
        
        //check for matches in dataList
        if !dataList.isEmpty {
            for string in dataList {
                if string.lowercaseString.hasPrefix((inputText?.lowercaseString)!) {
                    
                    displayAutoComplete(string, cursorPositionTextRange: selectedTextRange!)
                    foundAutoCompleteMatch = true
                    break
                }
            }
            
            //make sure autoComplete text from previous match doesn't get left in field when input changes to a non-matching string
            if !foundAutoCompleteMatch {
                text = inputText
            }
        }
    }
    
    func displayAutoComplete (string: String, cursorPositionTextRange: UITextRange) {
        
        text = string
        selectedTextRange = cursorPositionTextRange
        
        let inputTextRange: UITextRange? = textRangeFromPosition(beginningOfDocument, toPosition: selectedTextRange!.start)
        
        let autoCompleteTextRange: UITextRange? = textRangeFromPosition(selectedTextRange!.start, toPosition: endOfDocument)
        
        attributedText = getColoredText(textInRange(inputTextRange!)!, autoCompleteText: textInRange(autoCompleteTextRange!)!)
        
        selectedTextRange = cursorPositionTextRange
        
    }
    
    //getColoredText adapted from https://stackoverflow.com/questions/14231879/is-it-possible-to-change-color-of-single-word-in-uitextview-and-uitextfield
    
    func getColoredText(inputText: String, autoCompleteText: String) -> NSMutableAttributedString {
        
        let text: NSMutableAttributedString = NSMutableAttributedString(string: (inputText + autoCompleteText))

        let range:NSRange = (text.string as NSString).rangeOfString(autoCompleteText)
        
        text.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: range)
        
        return text
    }
    
    func textToBlack () {
        text = attributedText?.string
    }
    
}