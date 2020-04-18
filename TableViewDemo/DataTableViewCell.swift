//
//  DataTableViewCell.swift
//  TableViewDemo
//
//  Created by Manoj Shivhare on 03/04/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellNameLabel: UILabel?
    
    @IBOutlet weak var cellDescriptionLabel: UILabel?
    
    
    @IBOutlet weak var cellOpenIssuesCountLabel: UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
