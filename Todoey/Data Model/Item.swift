//
//  Item.swift
//  Todoey
//
//  Created by Mauro Farabegoli on 5/21/19.
//  Copyright © 2019 Mauro Farabegoli M. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? // = Date()
   
    // Reverse relationship (Many-to One relationship):
    // each item has a Parent Category
    // ((( var parentCategory = LinkingObjects(fromType: Object.Type, property: <#T##String#>) )))
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    // "Category.self" es igual al tipo de Category
    
   }
