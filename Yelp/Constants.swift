//
//  Constants.swift
//  Yelp
//
//  Created by Laura on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

struct Constants {
    
    static let businessCellIReuseIdentifier = "BusinessCell"
    
    static let switchCellReuseIdentifier = "SwitchCell"
    
    static let checkMarkCellReuseIdentifier = "CheckMarkCell"
    
    static let seeAllCellReuseIdentifier = "SeeAllCell"
    
    // In the following dictionaries "name" is what is displayed in the app's filter and "code" is what the API expects
    static let yelpCategories = [["name" : "American (Traditional)", "code" : "tradamerican"],
                                 ["name" : "Barbeque", "code" : "bbq"],
                                 ["name" : "Breakfast & Brunch", "code" : "breakfast_brunch"],
                                 ["name" : "Cajun/Creole", "code" : "cajun"],
                                 ["name" : "Cheesesteaks", "code" : "cheesesteaks"],
                                 ["name" : "Chinese", "code" : "chinese"],
                                 ["name" : "Cuban", "code" : "cuban"],
                                 ["name" : "Ethiopian", "code" : "ethiopian"],
                                 ["name" : "German", "code" : "german"],
                                 ["name" : "Greek", "code" : "greek"],
                                 ["name" : "Indian", "code" : "indian"],
                                 ["name" : "Italian", "code" : "italian"],
                                 ["name" : "Japanese", "code" : "japan"],
                                 ["name" : "Korean", "code" : "korean"],
                                 ["name" : "Mediterranean", "code" : "mediterranean"],
                                 ["name" : "Mexican", "code" : "mexican"],
                                 ["name" : "Middle Eastern", "code" : "mideastern"],
                                 ["name" : "Persian/Iranian", "code" : "persian"],
                                 ["name" : "Pizza", "code" : "pizza"],
                                 ["name" : "Sandwiches", "code" : "sandwiches"],
                                 ["name" : "Seafood", "code" : "seafood"],
                                 ["name" : "Steakhouses", "code" : "steak"],
                                 ["name" : "Tapas/Small Plates", "code" : "tapasmallplates"],
                                 ["name" : "Thai", "code" : "thai"],
                                 ["name" : "Vegetarian", "code" : "vegetarian"],
                                 ["name" : "Vietnamese", "code" : "vietnamese"],
                                 ["name" : "Romanian", "code": "romanian"]]
    
    static let yelpSort = [["name" : "Best Match", "code" : "0"],
                           ["name" : "Distance", "code" : "1"],
                           ["name" : "Highest Rated", "code" : "2"]]
    
    static let yelpDistance = [["name" : "0,2 km", "code" : "200"],
                               ["name" : "0,8 km", "code" : "800"],
                               ["name" : "1,5 km", "code" : "1500"],
                               ["name" : "8 km", "code" : "8000"]]
    
    static let yelpDeals = [["name": "Deals on/off", "code" : "true"]]
    
    static let yelpFilters = [yelpDeals, yelpDistance, yelpSort, yelpCategories]
    
    static let sectionNames = ["Deals", "Distance", "Sort By", "Categories"]
    
    static let filterKeys = ["deals", "distance", "sort", "categories"]
}
