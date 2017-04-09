//
//  Filter.swift
//  Yelp
//
//  Created by Laura on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

class Filter {
    
    var categoryName: String?
    var categorySwitchState: Bool?
    
    init(categories: [String: String], categorySwitchState: Bool) {
        self.categoryName = categories["name"]
        self.categorySwitchState = categorySwitchState
    }
    
    class func filters(categories: [[String: String]], switchStates: [Bool]) -> [Filter] {
        var filters: [Filter] = []
        
        for (key, _) in switchStates.enumerated() {
            let filter = Filter(categories: categories[key],categorySwitchState: switchStates[key])
            filters.append(filter)
        }
        
        return filters
    }
}
