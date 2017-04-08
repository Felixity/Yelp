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
    var switchStates = [Int: Bool]()
    
    var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = Contants.yelpCategories
        
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
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        
        for (row, isSwitchSelected) in switchStates {
            if isSwitchSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        return filters
    }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Contants.filterCellReuseIdentifier, for: indexPath) as! FilterCell
        cell.category = categories[indexPath.row]
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        
        cell.delegate = self
        return cell
    }
}

extension FiltersViewController: FilterCellDelegate {
    
    func filterCell(filterCell: FilterCell, didChangeValue value: Bool) {
        let index = tableView.indexPath(for: filterCell)?.row
        switchStates[index!] = value
    }
}
