//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Laura on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [[String: String]]!
    var switchStates: [Bool]!
    var filters: [Filter] = []
    
    var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = Constants.yelpCategories
        switchStates = Array(repeating: false, count: categories.count)
        filters = Filter.filters(categories: Constants.yelpCategories, switchStates: switchStates)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearch(_ sender: Any) {
        let filters = updateSelectedCategories()
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: filters)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateSelectedCategories() -> [String: AnyObject] {
        var activeFilters: [String: AnyObject] = [:]
        var selectedCategories: [String] = []
        
        for (index, filter) in filters.enumerated() {
            if let switchState = filter.categorySwitchState
            {
                if switchState {
                    selectedCategories.append(Constants.yelpCategories[index]["code"]!)
                }
            }
        }
        
        if selectedCategories.count > 0 {
            activeFilters["categories"] = selectedCategories as AnyObject?
        }
        
        return activeFilters
    }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.filterCellReuseIdentifier, for: indexPath) as! FilterCell
        cell.filter = filters[indexPath.row]
        
        cell.delegate = self
        return cell
    }
}

extension FiltersViewController: FilterCellDelegate {
    
    func filterCell(filterCell: FilterCell, didChangeValue value: Bool) {
        let index = tableView.indexPath(for: filterCell)?.row
        filters[index!].categorySwitchState = value
    }
}
