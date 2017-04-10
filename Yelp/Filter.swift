//
//  Filter.swift
//  Yelp
//
//  Created by Laura on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

class Filter {
    
    var itemName: String?
    var itemCode: String?
    var itemState: Bool?
    
    init(item: [String: String], itemState: Bool) {
        self.itemName = item["name"]
        self.itemCode = item["code"]
        self.itemState = itemState
    }
    
    class func filters(items: [[[String: String]]]) -> [[Filter]] {
        
        // This function is used create the Filter's model based on values from Constants.yelpFilters
        
        var filters: [[Filter]] = []
        var sectionFilters: [Filter] = []
        
        for (section, sectionItems) in items.enumerated() {            
            for (indexItem, _) in sectionItems.enumerated() {
                let filter = Filter(item: items[section][indexItem],itemState: false)
                sectionFilters.append(filter)
            }
            filters.append(sectionFilters)
            
            // Before setting the filters for the next sections, delete the elements of sectionFilters array
            sectionFilters.removeAll()
        }
        
        return filters
    }
}
