//
//  BookListCustomCell.swift
//  BookStorage
//
//  Created by Poonam Yadav on 12/08/19.
//  Copyright © 2019 poonamyadav. All rights reserved.
//

import Foundation
import UIKit


/*
 TableView Custom Cell for showing books. This is been customized to render alternate rows based on different CellIdentifier provided in respective storyboard
 */

class  BookListCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var bookIconView: UIImageView!
    
    @IBOutlet weak var bookAuthorNameLabel: UILabel!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    
    
}
