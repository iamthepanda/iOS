//
//  UIPickerViewController.swift
//  SMP_Says
//
//  Created by Evan Edge on 3/27/16.
//  Copyright © 2016 Stuff My Professor Says. All rights reserved.
//

import UIKit
import Foundation

class UIPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerDataSource: NSArray = []
    
    let path = NSBundle.mainBundle().pathForResource("Subjects", ofType: "txt")
    let text = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
    let pickerDataSource : [String] = text.componentsSeparatedByString("\n")



    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSoruce.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
    }
}