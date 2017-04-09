//
//  Cell.swift
//  DreamLister
//
//  Created by PRO on 4/8/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    
    func cellConfig(item: Item) {
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
    }
}
