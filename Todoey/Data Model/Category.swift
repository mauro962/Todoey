//
//  Category.swift
//  Todoey
//
//  Created by Mauro Farabegoli on 5/21/19.
//  Copyright © 2019 Mauro Farabegoli M. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    // Forward relationship : Each category has a list of items:
    let items = List<Item>()
}
