//
//  QuoteCell.swift
//  SMP_Says
//
//  Created by Monte's Pro 13" on 2/5/16.
//  Copyright © 2016 MonteThakkar. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {
    
    @IBOutlet weak var quotationLabel: UILabel!
    
    var quote : Quote! {
        didSet {
            quotationLabel.text = quote.quotation
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
