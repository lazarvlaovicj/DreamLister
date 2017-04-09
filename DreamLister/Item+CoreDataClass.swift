//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by PRO on 4/8/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)

public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
    
}
